# Etap 1: Budowanie aplikacji serwera
FROM node:14-alpine AS build

# Autor pliku Dockerfile
LABEL author="Alina Katrych"

# Ustawienie katalogu roboczego
WORKDIR /app

# Skopiowanie plików aplikacji serwera do kontenera
COPY package*.json ./
COPY server.js ./

# Zainstalowanie zależności
RUN npm install

# Etap 2: Uruchomienie aplikacji serwera
FROM node:14-alpine

# Autor pliku Dockerfile
LABEL author="Alina Katrych"

# Ustawienie katalogu roboczego
WORKDIR /app

# Skopiowanie plików aplikacji serwera z poprzedniego etapu
COPY --from=build /app .

# Dodanie informacji o dacie uruchomienia serwera do pliku logów
RUN echo "$(date) - Serwer został uruchomiony." >> logs.txt

# Wybór portu, na którym serwer będzie nasłuchiwał na zgłoszenia klienta
ENV PORT=3000

# Dodanie zdrowia aplikacji
HEALTHCHECK --interval=30s CMD curl -f http://localhost:${PORT}/health || exit 1

# Uruchomienie serwera
CMD ["node", "server.js"]
