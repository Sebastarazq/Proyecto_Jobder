import jwt from 'jsonwebtoken';

const generarJWT = datos => {
    console.log('Datos para generar el token:', datos);
    return jwt.sign({ id: datos.id, email: datos.email }, process.env.JWT_SECRET, { expiresIn: '4m' });
};

const generarJWTlargo = datos => {
    console.log('Datos para generar el token:', datos);
    return jwt.sign({ id: datos.id, email: datos.email }, process.env.JWT_SECRET, { expiresIn: '90d' });
};

const generaCodigo = () => {
    const codigo = Math.floor(10000 + Math.random() * 90000); // Genera un número aleatorio de 5 dígitos
    return codigo.toString(); // Convierte el número a cadena y lo devuelve
};

const decodificarJWT = token => {
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        return decoded;
    } catch (error) {
        throw error;
    }
};

const verificarJWT = token => {
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        return decoded;
    } catch (error) {
        throw new Error('Token de autenticación inválido');
    }
};

export {
    generarJWT,
    generaCodigo,
    decodificarJWT,
    generarJWTlargo,
    verificarJWT

};
