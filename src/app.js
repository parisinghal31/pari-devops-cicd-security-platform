// Minimal sample Node.js application used to demonstrate CI/CD scanning.
"use strict";

function add(a, b) {
  return a + b;
}

function divide(a, b) {
  if (b === 0) {
    throw new Error("division by zero");
  }
  return a / b;
}

function greet(name) {
  const cleaned = (name || "guest").trim();
  return `Hello, ${cleaned}!`;
}

if (require.main === module) {
  console.log(greet("DevOps"));
  console.log("2 + 3 =", add(2, 3));
}

module.exports = { add, divide, greet };
