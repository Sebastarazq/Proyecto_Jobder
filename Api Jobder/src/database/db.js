import Sequelize from "sequelize";
import dotenv from 'dotenv';
dotenv.config({ path: '.env' });

console.log('DATABASEDOCKER', process.env.DATABASEDOCKER, 'USERDOCKER', process.env.USERDOCKER, 'PASSWORDDOCKER', process.env.PASSWORDDOCKER, 'BD_HOSTDOCKER', process.env.DB_HOSTDOCKER, 'MYSQLDB_DOCKER_PORT', process.env.MYSQLDB_DOCKER_PORT);

const db = new Sequelize(process.env.DATABASEDOCKER, process.env.USERDOCKER, process.env.PASSWORDDOCKER, {
    host: process.env.DB_HOSTDOCKER,
    port: process.env.MYSQLDB_DOCKER_PORT,
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