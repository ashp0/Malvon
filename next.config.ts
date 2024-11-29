import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  eslint: {
    ignoreDuringBuilds: true,
  },
  basePath: "/malvon-browser",
};

module.exports = nextConfig;

export default nextConfig;
