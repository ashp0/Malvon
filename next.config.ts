import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  basePath: "/malvon-browser",
  output: "export", // <=== enables static exports
  reactStrictMode: true,
};

module.exports = nextConfig;

export default nextConfig;
