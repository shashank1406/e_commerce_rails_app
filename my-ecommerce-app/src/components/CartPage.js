import React, { useEffect, useState } from "react";
import axios from "axios";
import { getCart, order } from "./common";
import { useNavigate } from "react-router-dom";

const styles = {
  container: {
    fontFamily: "Arial, sans-serif",
    margin: "20px",
  },
  heading: {
    textAlign: "center",
  },
  table: {
    width: "100%",
    borderCollapse: "collapse",
    margin: "20px 0",
  },
  th: {
    border: "1px solid #ddd",
    padding: "10px",
    textAlign: "left",
    backgroundColor: "#f2f2f2",
  },
  td: {
    border: "1px solid #ddd",
    padding: "10px",
    textAlign: "left",
  },
  total: {
    textAlign: "right",
    marginTop: "10px",
  },
  checkoutBtn: {
    backgroundColor: "#4CAF50",
    color: "white",
    padding: "10px",
    border: "none",
    borderRadius: "4px",
    cursor: "pointer",
    margin:"20px"
  },
  removeBtn: {
    backgroundColor: "#f44336",
    color: "white",
    padding: "8px",
    border: "none",
    borderRadius: "4px",
    cursor: "pointer",
  },
};

const CartPage = () => {
  const navigate = useNavigate();
  const [cartItems, setCartItems] = useState([]);

  const [totalPrice, setTotalPrice] = useState();

  const tokenStr = localStorage.getItem("token");
  useEffect(() => {
    axios
      .get(getCart, {
        headers: { Authorization: `Bearer ${tokenStr}` },
      })
      .then((response) => {
        setCartItems(response.data.products);
        setTotalPrice(response.data.order_detail.total_price);
      });
  }, []);

  const updateQuantity = (id, newQuantity) => {
    if (newQuantity > 0) {
      axios
        .put(
          `${order}/${id}`,
          {
            quantity: newQuantity,
          },
          {
            headers: { Authorization: `Bearer ${tokenStr}` },
          }
        )
        .then((response) => {
          const updatedCartItems = cartItems.map((item) =>
            item.id === id ? { ...item, quantity: newQuantity } : item
          );
          const product = cartItems.find((item) => item.id === id);
          setCartItems(updatedCartItems);
          setTotalPrice(
            totalPrice -
              product.price * product.quantity +
              newQuantity * product.price
          );
        })
        .catch((error) => {
          alert(error.response.data.errors);
        });
    } else {
      alert("product quantity not less then one");
    }
  };

  const removeItem = (id) => {
    axios
      .delete(`${order}/${id}`, {
        headers: { Authorization: `Bearer ${tokenStr}` },
      })
      .then((response) => {
        const updatedCartItems = cartItems.filter((item) => item.id !== id);
        const product = cartItems.find((item) => item.id === id);
        setCartItems(updatedCartItems);
        setTotalPrice(totalPrice - product.quantity * product.price);
      })
      .catch((error) => {
        alert(error.response.data.errors);
      });
  };

  const handleCheckout = () => {
    // Implement your checkout logic here
    alert("Checkout functionality is not implemented in this example.");
  };

  return (
    <div style={styles.container}>
      <h2 style={styles.heading}>Your Shopping Cart</h2>

      <table style={styles.table}>
        <thead>
          <tr>
            <th style={styles.th}>Product Name</th>
            <th style={styles.th}>Product Description</th>
            <th style={styles.th}>Quantity</th>
            <th style={styles.th}>Price</th>
            <th style={styles.th}>Remove</th>
          </tr>
        </thead>
        <tbody>
          {cartItems.map((item) => (
            <tr key={item.id}>
              <td style={styles.td}>{item.name}</td>
              <td style={styles.td}>{item.description}</td>
              <td style={styles.td}>
                <input
                  type="number"
                  value={item.quantity}
                  onChange={(e) =>
                    updateQuantity(item.id, parseInt(e.target.value, 10))
                  }
                  min={1}
                />
              </td>
              <td style={styles.td}>${item.price.toFixed(2)}</td>
              <td style={styles.td}>
                <button
                  style={styles.removeBtn}
                  onClick={() => removeItem(item.id)}
                >
                  Remove
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      <div style={styles.total}>
        <strong>Total Price: ${totalPrice}</strong>
      </div>

      <button style={styles.checkoutBtn} onClick={handleCheckout}>
        Checkout
      </button>
      <button style={styles.checkoutBtn} onClick={() => {navigate('/product')}}>
        Continue Shpooing
      </button>
    </div>
  );
};

export default CartPage;
