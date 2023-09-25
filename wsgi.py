
from eventlet import wsgi
import eventlet
from app import app

from app.scheduler import sched

from app.features.dating import socketio

if __name__ == "__main__":
    # app.run(host="0.0.0.0", port=80, debug=True)
    sched.start()

    # wsgi.server(eventlet.listen(('0.0.0.0', 5000)), app)
    app.run(host="0.0.0.0", port=5000, debug=True, use_debugger=False, use_reloader=False)
