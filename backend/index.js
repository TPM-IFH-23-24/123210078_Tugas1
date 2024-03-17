require("dotenv").config();
const express = require("express");
const cors = require("cors");
const connection = require("./config");
const bcrypt = require("bcrypt");
const { nanoid } = require("nanoid");
const app = express();
const server = require("http").createServer(app);
const host = process.env.HOST;
const port = process.env.PORT || "3100";

server.listen(port, () => {
  console.log("Server Connected on: http://" + host + ":" + port + "/");
});

app.use(cors());
app.use(express.json());

// [POST] Login existing user
app.post("/v1/users/login", async (req, res, next) => {
  try {
    const { username, password } = req.body;

    if (username == "" || password == "") {
      const error = new Error(`Username or password cannot be empty.`);
      error.statusCode = 401;
      throw error;
    }

    // Cek user ada apa engga
    const checkCommand = `SELECT * FROM users WHERE username = ?`;
    const [[user]] = await connection.promise().query(checkCommand, [username]);

    if (!user) {
      const error = new Error("Wrong email or password");
      error.statusCode = 404;
      throw error;
    }

    const checkPassword = await bcrypt.compare(password, user.password);

    // Apabila password salah
    if (!checkPassword) {
      const error = new Error("Wrong email or password");
      error.statusCode = 404;
      throw error;
    }

    res.status(200).json({
      status: "Success",
      message: "Login Successful",
    });
  } catch (error) {
    res.status(error.statusCode || 500).json({
      status: "Error",
      message: error.message,
    });
  }
});

// [POST] Register new user
app.post("/v1/users/register", async (req, res, next) => {
  try {
    const { username, password } = req.body;

    if (username == "" || password == "") {
      const error = new Error(`Cannot be empty.`);
      error.statusCode = 401;
      throw error;
    }

    const salt = await bcrypt.genSalt(6);
    const hashedPassword = await bcrypt.hash(password, salt);
    const id = nanoid();

    // Cek apakah username udah ada atau engga
    const checkCommand = `SELECT id FROM users WHERE username = ?`;
    const [[checkId]] = await connection
      .promise()
      .query(checkCommand, [username]);

    if (checkId) {
      const error = new Error(`Username ${username} already exist!`);
      error.statusCode = 401;
      throw error;
    }

    // Insert data ke tabel User
    const inserCommand = `INSERT INTO users VALUES (?, ?, ?)`;
    await connection
      .promise()
      .query(inserCommand, [id, username, hashedPassword]);

    // Send response
    res.status(201).json({
      status: "Success",
      message: "Register Successful",
    });
  } catch (error) {
    res.status(error.statusCode || 500).json({
      status: "Error",
      message: error.message,
    });
  }
});
