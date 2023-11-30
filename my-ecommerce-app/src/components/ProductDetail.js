// ProductDetail.js
import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import {
  Card,
  CardContent,
  CardMedia,
  Typography,
  Button,
  Container,
  Grid,
  TextField,
} from "@mui/material";
import axios from "axios";
import { getProductsURL, order } from "./common";
import image from "../assests/download.png";
import { useNavigate } from "react-router-dom";

const ProductDetail = () => {
  const { productId } = useParams();
  const navigate = useNavigate();
  const [product, setProduct] = useState([]);
  const [quantity, setQuantity] = useState(1);
  const tokenStr = localStorage.getItem("token");

  useEffect(() => {
    axios
      .get(`${getProductsURL}/${productId}`, {
        headers: { Authorization: `Bearer ${tokenStr}` },
      })
      .then((response) => {
        setProduct(response.data);
      });
  }, []);

  const handleAddToCart = () => {
    axios
      .post(
        order,
        {
          product_id: productId,
          price: product.price,
          quantity: quantity,
        },
        { headers: { Authorization: `Bearer ${tokenStr}` } }
      )
      .then((response) => {
        navigate("/cart");
      })
      .catch((error) => {
        console.log(error.response.data.error);
      });
  };

  if (!product) {
    return <div>Product not found</div>;
  }

  return (
    <Container maxWidth="md" style={{ marginTop: "2rem" }}>
      <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
          <Card>
            <CardMedia
              component="img"
              alt={product.name}
              height="300"
              image={image}
            />
          </Card>
        </Grid>
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h5" gutterBottom>
                {product.name}
              </Typography>
              <Typography color="textSecondary">
                {product.description}
              </Typography>
              <Typography variant="h6" style={{ marginTop: "1rem" }}>
                Price: ${product.price}
              </Typography>
              <TextField
                type="number"
                label="Quantity"
                variant="outlined"
                value={quantity}
                onChange={(e) =>
                  setQuantity(Math.max(1, parseInt(e.target.value, 10)))
                }
                inputProps={{ min: 1 }}
                style={{ marginTop: "1rem" }}
              />
              <Button
                variant="contained"
                color="primary"
                style={{ marginTop: "1rem" }}
                onClick={handleAddToCart}
              >
                Add to Cart
              </Button>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Container>
  );
};

export default ProductDetail;
