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

const comparePasswords = async (plainPassword, hashedPassword) => {
  try {
    const isValid = await bcrypt.compare(plainPassword, hashedPassword);
    return isValid;
  } catch (error) {
    throw error;
  }
};

export {
  hashPassword,
  comparePasswords
};
