from flask import Flask
from models.models import db, login_manager

root = Flask(__name__)
root.config['UPLOAD_FOLDER'] = "static"
root.config["SECRET_KEY"] = "942acc9ac21231fa1872f963"
root.config["SQLALCHEMY_DATABASE_URI"] = "postgresql+psycopg2://skylog:skylog@localhost:5432/logist_smart"

db.init_app(root)
login_manager.init_app(root)

# Регистрация маршрутов и обработчиков ошибок
from routes.main_route import *
from routes.student_route import *
from routes.reception_route import *
root.register_error_handler(404, page_not_found)
root.register_error_handler(401, unauthorized)

with root.app_context():
    db.create_all()

if __name__ == "__main__":
    root.run(debug=True, port=8080, host='0.0.0.0')


# from flask import Flask
# from models.models import db, login_manager
# #engine = create_engine(url="postgresql+psycopg2://akbarov:akbarov@localhost/logist_smart", echo=True, pool_size=180, max_overflow=250)
#
# app = Flask(__name__)
# app.config['UPLOAD_FOLDER'] = "static"
# app.config["SECRET_KEY"] = "942acc9ac21231fa1872f963"
# app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql+psycopg2://skylog:skylog@localhost:5432/logist_smart"
#
# #"postgresql+psycopg2://akbarov:akbarov@localhost/logist_smart"
# db.init_app(app)
# login_manager.init_app(app)
#
# with app.app_context():
#     db.create_all()
#
# if __name__ == "__main__":
#     from routes.main_route import *
#     from routes.student_route import *
#     from routes.reception_route import *
#     app.register_error_handler(404, page_not_found)
#     app.register_error_handler(401, unauthorized)
#     app.run(debug = True, port=8080, host='0.0.0.0')
