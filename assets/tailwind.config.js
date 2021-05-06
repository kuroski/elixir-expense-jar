module.exports = {
  // mode: "jit",
  purge: {
    enabled: process.env.NODE_ENV === "production",
    content: [
      "../lib/**/*.ex",
      "../lib/**/*.leex",
      "../lib/**/*.eex",
      "./js/**/*.js",
    ],
    options: {
      whitelist: [/phx/, /nprogress/]
    }
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/forms")],
};
