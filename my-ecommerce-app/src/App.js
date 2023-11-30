import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./components/Login";
import Signup from "./components/Signup";
import ProductList from "./components/ProductList";
import ProductDetail from "./components/ProductDetail";
import HomePage from "./components/HomePage";
import CartPage from "./components/CartPage";

const App = () => {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route exact path="/" element={<HomePage />}></Route>
          <Route exact path="/login" element={<Login />}></Route>
          <Route exact path="/signup" element={<Signup />}></Route>
          <Route exact path="/product" element={<ProductList />}></Route>
          <Route
            exact
            path="/product/:productId"
            element={<ProductDetail />}
          ></Route>
          <Route exact path="/cart" element={<CartPage />}></Route>
        </Routes>
      </div>
    </Router>
  );
};

export default App;
