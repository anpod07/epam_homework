#!/home/ninja/pyapp/pyappvenv/bin/python
import socket
from flask import Flask
from flask import render_template
from flask import request
from flask import redirect
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from sqlalchemy.exc import OperationalError, ProgrammingError
from flask import session


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = "mysql://admin:07secret07@rds-mysql.c2zjjwdqinpi.eu-central-1.rds.amazonaws.com:3306/db_test"
session_options = {'autocommit': True}
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.secret_key = "qwertyuiop"
db = SQLAlchemy(app, session_options = session_options)


@app.route('/', methods=['POST', 'GET'])
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


if __name__ == "__main__":
	app.run(host='0.0.0.0', debug=True)
