import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  eslint: {
    ignoreDuringBuilds: true,
  },
  basePath: "/malvon-browser",
  output: "export", // <=== enables static exports
};

module.exports = nextConfig;

export default nextConfig;
