# El Base
# Instala las dependencias de producción y copia el código.
FROM python:3.12-slim AS base
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# De Test
# Añade pytest sobre la base y ejecuta los tests.
FROM base AS test
COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt
CMD ["pytest", "-v"]

# De Desarrollo
# Servidor de desarrollo con auto-reload en el puerto 5000.
FROM base AS dev
EXPOSE 5000
CMD ["flask", "--app", "run", "run", "--debug", "--host", "0.0.0.0"]

# De Producción
# Parte de base (sin pytest) y arranca Gunicorn en el puerto 8000.
FROM base AS production
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "run:app"]