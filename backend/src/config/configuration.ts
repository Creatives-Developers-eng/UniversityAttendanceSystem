export default () => ({
  port: parseInt(process.env.PORT, 10) || 3000,
  nodeEnv: process.env.NODE_ENV || 'development',
  database: {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT, 10) || 5432,
    username: process.env.DB_USERNAME || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    name: process.env.DB_NAME || 'university_attendance_db',
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'super_secret_jwt_key_placeholder',
    expiresIn: process.env.JWT_EXPIRATION || '15m',
  },
});
