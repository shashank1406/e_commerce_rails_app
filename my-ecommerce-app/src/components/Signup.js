// Signup.js
import React, { useState } from "react";
import {
  TextField,
  Button,
  Container,
  Typography,
  CssBaseline,
  Link
} from "@mui/material";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { signUpURL } from "./common";


const Signup = ({ onSignup }) => {
  const navigate = useNavigate();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  const handleSignup = () => {
    if (
      username.trim() === "" ||
      password.trim() === "" ||
      confirmPassword.trim() === ""
    ) {
      alert("Please enter both email, password and confirm password.");
      return;
    }

    axios
      .post(signUpURL, {
        email: username,
        password: password,
        password_confirmation:confirmPassword
      })
      .then((response) => {
        localStorage.setItem('token',response.data.token);
        setUsername("");
        setPassword("");
        navigate("/product");
      }).catch(error => {
        alert(error.response.data.errors)
     })
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
          Sign Up
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

          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            name="confirm_password"
            label="Confirm Password"
            id="Confirm password"
            // autoComplete="current-password"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
          />

          <Button
            fullWidth
            variant="contained"
            color="primary"
            onClick={handleSignup}
            style={{ marginTop: "1rem" }}
          >
            Sign Up
          </Button>

          <Link href="/login">Already an account ? Login</Link>
        </form>
      </div>
    </Container>
  );
};

export default Signup;
