// src/components/HomePage.js
import React from 'react';
import { useEffect, useState } from "react";
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import { useNavigate } from "react-router-dom";
import Signup from './Signup';
import ProductList from './ProductList';


const HomePage = () => {
  const navigate = useNavigate();
  const [isLogin, setIsLogin] = useState("");


  useEffect(() => {
    setIsLogin(localStorage.getItem("token"))
  }, []);

  return (
    <Box
      style={{
        textAlign: 'center',
        backgroundColor: '#f0f0f0',
        minHeight: '100vh',
      }}
    >
      <Typography variant="h2" gutterBottom>
      Ecommerce website
      </Typography>
      <Signup/>
    </Box>
  );
};

export default HomePage;