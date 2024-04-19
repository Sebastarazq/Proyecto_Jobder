import bcrypt from 'bcrypt';

const hashPassword = async (password) => {
  try {
    const saltRounds = 10; // Número de rondas de sal para el hash
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    return hashedPassword;
  } catch (error) {
    throw error;
  }
};

export default {
  hashPassword
};
