import jwt from 'jsonwebtoken';

const generarJWT = datos => jwt.sign({ id: datos.id, nombre: datos.nombre }, process.env.JWT_SECRET, { expiresIn: '1d' });

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

export {
    generarJWT,
    generaCodigo,
    decodificarJWT
};
