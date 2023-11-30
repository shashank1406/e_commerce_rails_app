// Login.js
import React, { useState } from "react";
import "../Login.css";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import { LoginURL } from "./common";
import {
  TextField,
  Button,
  Container,
  Typography,
  CssBaseline,
  Link
} from "@mui/material";

const Login = ({ onLogin }) => {
  const navigate = useNavigate();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");

  const handleLogin = () => {
    if (username.trim() === "" || password.trim() === "") {
      alert("Please enter both username and password.");
      return;
    }
    axios
      .post(LoginURL, {
        email: username,
        password: password,
      })
      .then((response) => {

        localStorage.setItem("token", response.data.token);
        setUsername("");
        setPassword("");
        navigate("/product");
      })
      .catch((error) => {
        alert(error.response.data.error);
      });
  };

  return (
    <Container component="main" maxWidth="xs">
      <CssBaseline />
      <div
        style={{
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          paddingTop:'30%'
        }}
      >
        <Typography component="h1" variant="h5">
          Log In
        </Typography>
        <form style={{ width: "100%", marginTop: "1rem" }}>
          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            id="username"
            label="Email"
            name="username"
            autoComplete="username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            name="password"
            label="Password"
            type="password"
            id="password"
            autoComplete="current-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />

          <Button
            fullWidth
            variant="contained"
            color="primary"
            onClick={handleLogin}
            style={{ marginTop: "1rem" }}
          >
            Sign Up
          </Button>

          <Link href="/signup">Need an account ? SignUp</Link>

        </form>
      </div>
    </Container>
  );
};

export default Login;
