import nodemailer from 'nodemailer';

const emailRegistro = async (datos) => {
    const transport = nodemailer.createTransport({
        host: process.env.EMAIL_HOST,
        port: process.env.EMAIL_PORT,
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS
        }
    });

    const { email, nombre, token } = datos;

    try {
        // Enviar el correo
        await transport.sendMail({
            from: 'Jobder <noreply@jobder.com>',
            to: email,
            subject: 'Código de Confirmación de Jobder',
            text: 'Código de Confirmación de Jobder',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h2 style="color: #007bff;">¡Bienvenido a Jobder, ${nombre}!</h2>
                    <p style="font-size: 16px;">Para completar tu registro, necesitamos que confirmes tu cuenta con el siguiente código:</p>
                    <div style="background-color: #f4f4f4; padding: 20px; border-radius: 10px; text-align: center;">
                        <h3 style="color: #007bff; margin-bottom: 10px;">Código de Confirmación:</h3>
                        <p style="font-size: 24px; font-weight: bold; margin: 10px 0;">${token}</p>
                    </div>
                    <p style="font-size: 16px; margin-top: 20px;">Por favor, utiliza este código para confirmar tu cuenta en Jobder.</p>
                    <p style="font-size: 16px; color: #888;">Si no has solicitado este registro, por favor ignora este correo.</p>
                    <p style="font-size: 16px; color: #888;">¡Gracias por unirte a Jobder!</p>
                </div>
            `
        });

        console.log(`Correo de confirmación enviado a ${email}`);
    } catch (error) {
        console.error('Error al enviar el correo de confirmación:', error);
        throw error;
    }
};

export default emailRegistro;
