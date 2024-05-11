import Sequelize from "sequelize";
import dotenv from 'dotenv';
dotenv.config({ path: '.env' });


const db = new Sequelize(process.env.DATABASE_AZURE, process.env.USER_AZURE, process.env.PASSWORD_AZURE, {
    host: process.env.DB_HOST_AZURE,
    port: '3306',
    dialect: 'mysql',
    define: {
        timestamps: true
    },
    pool: {
        max: 5,
        min: 0,
        acquire: 30000,
        idle: 10000,
    },
    operatorAliases: false
});

export default db;