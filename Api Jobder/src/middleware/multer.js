import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';

// Obtén el directorio actual del módulo
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Configuración de Multer
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.join(__dirname, '../../public/uploads')); // Directorio donde se guardarán las imágenes
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9); // Nombre de archivo único
        cb(null, uniqueSuffix + '-' + file.originalname); // Nombre de archivo guardado en el servidor
    }
});

const upload = multer({ storage: storage });

export default upload;
