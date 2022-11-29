#!/home/ninja/pyapp/pyappvenv/bin/python
# Start Development Python Server
import socket							# модуль для распознования IP по имени хоста
from flask import Flask
from flask import render_template		# модуль для использования html-шаблонов из директории './templates'
from flask import request				# модуль для определения метода (GET, POST)
from flask import redirect				# модуль для перехода на другую страницу
from flask_sqlalchemy import SQLAlchemy	# модуль для работы с БД SQL
from sqlalchemy import text				# модуль для выполнения указанных SQL-запросов
from sqlalchemy.exc import OperationalError, ProgrammingError	# для отлова ошибок
from flask import session				# модуль для использования сессионных ключей (куки) https://stackoverflow.com/questions/17057191/redirect-while-passing-arguments


# Указать имя файла (), который будет запускаться с помощью Flask
# переменная '__name__' передает имя текущего файла (__main__ = app.py)
app = Flask(__name__)
#app = Flask(__name__,
#            static_url_path='',
#            static_folder='/home/andr/python-proj/templates/static',
#            template_folder='/home/andr/python-proj/templates')
# WORKED!!! But first install this:
#  - sudo apt install libmysqlclient-dev -y
#  - pip install mysqlclient (run this command in Virtual Enviroment 'venv')
app.config['SQLALCHEMY_DATABASE_URI'] = "mysql://root:secret@172.31.23.10:3306/db_test"
#app.config['SQLALCHEMY_DATABASE_URI'] = "mysql://root:secret@localhost/db_test"
#app.config['SQLALCHEMY_DATABASE_URI'] = "mysql://root:secret@my-db-svc/db_test"
session_options = {'autocommit': True}					# опция для автоматического сохранения БД (работало и без нее)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False	# отключаем неиспользуемые функции
app.secret_key = "qwertyuiop"							# устанавливаем секретный ключ для использования сессионных ключей
db = SQLAlchemy(app, session_options = session_options)


@app.route('/', methods=['POST', 'GET'])				# Переход на: http://172.16.31.119:5000/
def index():
	if request.method == 'POST':
		if request.form.get("btn_sqlquery"):
			sqlquery = (request.form.get("sqlquery"))
			try:
				if sqlquery.endswith(';;'):				# если в конце больше одного ';' - ошибка
					sqlstatus = 'your query is wrong'
					return render_template("index.html", sqlstatus=sqlstatus)
				if sqlquery.endswith(';'):				# если в конце ';' - убираем ';'
					sqlquery = sqlquery[:-1]
				viewall = []
				status = 0
				for i in sqlquery.split(';'):			# разбиваем строку sql-запроса на куски-запросы по разделителю ';'
					if i.startswith(' '):				# если sql-запрос начинается с пробела - убираем пробел вначале
						i = i[1:]
					if i.lower().startswith('insert') or sqlquery.lower().startswith('update') or sqlquery.lower().startswith('delete'):
						db.engine.execute(text(sqlquery))		# Если SQL-запрос начинается с 'insert','update' или 'delete', то ничего не выводим на экран, кроме статуса выполнения
						sqlstatus = 'query is done'
						status += 1
					else:
						vkey = list(db.engine.execute(text(i)).keys())
						view = db.engine.execute(text(i))
						viewall.append(vkey)
						viewall.append(view)
						status += 2
				if status == 1:							# выводим одиночный SQL-запрос 'insert','update' или 'delete'
					return render_template("index.html", sqlstatus=sqlstatus)
				else:									# выводим мульти-SQL-запросы 'select','show'; также потихому выполняются 'insert','update' или 'delete'
					return render_template("index.html", sqlquery=sqlquery, viewall=viewall)
			except OperationalError:					# Если SQL-запрос пустой
				sqlstatus = 'your query is empty'
				return render_template("index.html", sqlstatus=sqlstatus)
			except ProgrammingError:					# Если SQL-запрос с синтаксическими ошибками
				sqlstatus = 'your query is wrong'
				return render_template("index.html", sqlstatus=sqlstatus)
	else:
		return render_template("index.html")


# Если запускаем файл 'app.py', тогда стартуем DEVEL-web-сервер http://172.16.31.119:5000
if __name__ == "__main__":
	app.run(host='0.0.0.0', debug=True)
