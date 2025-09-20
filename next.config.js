/** @type {import('next').NextConfig} */
const nextConfig = {
  eslint: {
    // Tắt việc kiểm tra ESLint trong quá trình build
    ignoreDuringBuilds: true,
  },
  images: {
    domains: ['source.unsplash.com'],
  },
  webpack: (config) => {
    config.externals.push('canvas');
    return config;
  },
}

module.exports = nextConfig 