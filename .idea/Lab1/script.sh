# Задати URL сервера
url="https://www.github.com"

# Виконати запит до сервера і зберегти код відповіді
response_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")

# Перевірити код відповіді
if [[ "$response_code" =~ ^(2|3)[0-9]{2}$ ]]; then
  echo "Сервер повернув код $response_code: OK"
else
  echo "Помилка! Сервер повернув код $response_code"
  echo "$(date) - Код відповіді сервера: $response_code" >> error.log
fi
