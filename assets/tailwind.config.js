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
      safelist: [/phx/, /nprogress/, /input/, /type='text'/, /type='radio'/, /type='search'/, /form-input/],
    },
  },
  darkMode: "media", // or 'media' or 'class'
  theme: {
    container: {
      center: true,
      screens: {
        sm: "640px",
        md: "640px",
        lg: "640px",
        xl: "640px",
        "2xl": "640px",
      },
    },
    extend: {
      keyframes: {
        "fade-in": {
          "0%": {
            opacity: "0",
          },
          "100%": {
            opacity: "1",
          },
        },
        "fade-in-down": {
          "0%": {
            opacity: "0",
            transform: "translateY(-10px)",
          },
          "100%": {
            opacity: "1",
            transform: "translateY(0)",
          },
        },
        "fade-out-down": {
          from: {
            opacity: "1",
            transform: "translateY(0px)",
          },
          to: {
            opacity: "0",
            transform: "translateY(10px)",
          },
        },
        "fade-in-up": {
          "0%": {
            opacity: "0",
            transform: "translateY(10px)",
          },
          "100%": {
            opacity: "1",
            transform: "translateY(0)",
          },
        },
        "fade-out-up": {
          from: {
            opacity: "1",
            transform: "translateY(0px)",
          },
          to: {
            opacity: "0",
            transform: "translateY(10px)",
          },
        },
      },
      animation: {
        "fade-in": "fade-in-down 0.5s ease-out",
        "fade-in-down": "fade-in-down 0.5s ease-out",
        "fade-out-down": "fade-out-down 0.5s ease-out",
        "fade-in-up": "fade-in-up 0.5s ease-out",
        "fade-out-up": "fade-out-up 0.5s ease-out",
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/forms")({
    strategy: 'class',
  })],
};
