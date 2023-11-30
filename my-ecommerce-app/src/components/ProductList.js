
import React from "react";
import { useEffect, useState } from "react";
import {
  Card,
  CardContent,
  CardMedia,
  Typography,
  Grid,
  Container,
} from "@mui/material";
import { Link } from "react-router-dom";
import axios from "axios";
import { getProductsURL } from "./common";
import Button from "@mui/material/Button";
import { useNavigate } from "react-router-dom";

import image from "../assests/download.png";

const ProductList = () => {
  const navigate = useNavigate();
  const tokenStr = localStorage.getItem("token");
  const [products, setProducts] = useState([]);

  useEffect(() => {
    if(tokenStr){
      axios
      .get(getProductsURL, { headers: { Authorization: `Bearer ${tokenStr}` } })
      .then((response) => {
        setProducts(response.data);
      });
    }else{
      navigate("/signup");
    }
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("token");
    navigate("/");
  };

  return (
    <div>
      <Button variant="contained" onClick={handleLogout}>
        Log Out
      </Button>
      <Button
        variant="contained"
        onClick={() => {
          navigate("/cart");
        }}
      >
        Cart
      </Button>
      <Container maxWidth="md" style={{ marginTop: "2rem" }}>
        <Grid container spacing={3}>
          {products.map((product) => (
            <Grid item key={product.id} xs={12} sm={6} md={4}>
              <Link to={`/product/${product.id}`}>
                <Card>
                  <CardMedia
                    component="img"
                    alt={product.name}
                    height="140"
                    image={image}
                  />
                  <CardContent>
                    <Typography variant="h6">{product.name}</Typography>
                    <Typography color="textSecondary">
                      {product.description}
                    </Typography>
                  </CardContent>
                </Card>
              </Link>
            </Grid>
          ))}
        </Grid>
      </Container>
    </div>
  );
};

export default ProductList;
