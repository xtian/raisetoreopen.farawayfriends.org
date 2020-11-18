module.exports = {
  purge: {
    enabled: process.env.MIX_ENV == "prod",
    mode: "layers",
    content: [
      "../lib/raise_to_reopen_web/components/**/*.ex",
      "../lib/raise_to_reopen_web/components/**/*.html.leex",
      "../lib/raise_to_reopen_web/live/**/*.ex",
      "../lib/raise_to_reopen_web/live/**/*.html.leex",
      "../lib/raise_to_reopen_web/templates/**/*.html.eex",
      "../lib/raise_to_reopen_web/templates/**/*.html.leex",
    ],
  },
  theme: {
    colors: {
      black: "#000",
      blue: {
        100: "#8accc7",
        300: "#2ab2b7",
      },
      green: "#a3c75c",
      gray: {
        100: "#e0e0e0",
        300: "#3b3b3b",
      },
      pink: {
        100: "#fc4a86",
        300: "#e94e82",
      },
      red: "#ff494c",
      white: "#fff",
      yellow: "#fbb018",
    },
    extend: {
      fontFamily: {
        sans: [
          '"Proxima Nova"',
          "system-ui",
          "-apple-system",
          "BlinkMacSystemFont",
          '"Segoe UI"',
          "Roboto",
          '"Helvetica Neue"',
          "Arial",
          '"Noto Sans"',
          "sans-serif",
          '"Apple Color Emoji"',
          '"Segoe UI Emoji"',
          '"Segoe UI Symbol"',
          '"Noto Color Emoji"',
        ],
      },
    },
  },
};
