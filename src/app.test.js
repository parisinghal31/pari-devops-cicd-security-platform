const { add, divide, greet } = require("./app");

test("add", () => {
  expect(add(2, 3)).toBe(5);
  expect(add(-1, 1)).toBe(0);
});

test("divide", () => {
  expect(divide(10, 2)).toBe(5);
  expect(() => divide(1, 0)).toThrow("division by zero");
});

test("greet", () => {
  expect(greet("Pari")).toBe("Hello, Pari!");
  expect(greet("")).toBe("Hello, guest!");
});
