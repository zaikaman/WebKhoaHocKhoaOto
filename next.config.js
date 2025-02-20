/** @type {import('next').NextConfig} */
const nextConfig = {
  eslint: {
    // Tắt việc kiểm tra ESLint trong quá trình build
    ignoreDuringBuilds: true,
  },
}

module.exports = nextConfig 