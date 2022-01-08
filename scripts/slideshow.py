"""Display images from media folder as slide show

Author: Matthias Kastner

ToDo:
- read email from /home/pi/.getmail/getmailrc

"""

import tkinter
import os
import PIL.ImageTk
import logging.config
import functools
import yaml
import time
import sys

from threading import Thread
import signal
import random

cycle_time = 10000
images = iter(list())
meta = dict()
email = 'dummy@ab.cd'
shuffle = True

script_path = os.path.dirname(os.path.abspath(__file__))
project_path = os.path.abspath(os.path.join(script_path, '..'))
print(f'Project root: {project_path}', file=sys.stderr)

with open(os.path.join(project_path, 'logging.yml')) as fso:
  logging.config.dictConfig(yaml.safe_load(fso.read()))
logger = logging.getLogger('photoframe')

images_path = os.path.join(project_path, 'media')
logger.debug(f'Images path: {images_path}')
meta_file = os.path.join(project_path, 'media', 'meta.yml')
logger.debug(f'Images meata file: {meta_file}')
logo = os.path.join(project_path, 'img/logo.png')


class SlideShow(Thread):
  ready = False

  def run(self):
    self.root = tkinter.Tk()
    self.root.attributes('-zoomed', True)  # maximize window
    self.root.wm_attributes('-fullscreen', 'True')  # remove titlebar
    self.root.configure(background='white')
    self.logger = logging.getLogger('photoframe.app')
    self.ready = True
    self.root.mainloop()


def sigint_handler(sig, frame):
    app.root.quit()
    app.root.update()


def load_images():
  logger.info('reloading images')
  files = map(os.path.splitext, os.listdir(images_path))
  images = list(filter(lambda x: x[1].lower() in ['.jpg', '.jpeg', '.png'], files))
  if shuffle:
    random.shuffle(images)
  with open(meta_file) as fso:
    meta = yaml.safe_load(fso.read())
  return meta, map(lambda x: os.path.join(images_path, ''.join(x)), images)


@functools.lru_cache(maxsize=64)
def resize_image(file_name):
  app.logger.debug(f'Processing "{file_name}"')
  image = PIL.Image.open(file_name)
  image_width = float(image.size[0])
  image_height = float(image.size[1])
  aspect = image_width / image_height
  if image_height > image_width:
    app.logger.debug('portrait mode')
    scaling = float(screen_height / image_height)
    image_width = min(screen_width, round(image_width * scaling))
    image_height = round(image_width / aspect)
  else:
    app.logger.debug('landscape mode')
    scaling = float(screen_width / image_width)
    image_height = min(screen_height, round(image_height * scaling))
    image_width = round(aspect * image_height)
  app.logger.debug(f'width: {image_width}, height: {image_height}, scaling: {scaling:.2f}')
  return image.resize((image_width, image_height), PIL.Image.NEAREST)


def next_image():
  global images, meta
  try:
    file_name = next(images)
    image = resize_image(file_name)
  except StopIteration:
    meta, images = load_images()
    return next_image()
  except PIL.UnidentifiedImageError:
    app.logger.warning('Image not readable.')
    return next_image()
  tkimage = PIL.ImageTk.PhotoImage(image)
  label_image.config(image=tkimage)
  label_image.image = tkimage
  label_image.place(relx=0.5, rely=0.5, anchor=tkinter.CENTER)
  try:
    _, key = os.path.split(file_name)
    metadata = meta[key]
    logger.info(f'Meta Info: {metadata}')
  except KeyError:
    metadata = file_name
  label_meta.config(text=metadata)
  label_meta.text = metadata
  label_meta.place(relx=0.5, y=0, anchor=tkinter.N)
  app.root.after(cycle_time, next_image)


app = SlideShow()
signal.signal(signal.SIGINT, sigint_handler)
app.start()
while not app.ready:
  logger.debug('waiting for app to get ready')
  time.sleep(1)
screen_width, screen_height = app.root.winfo_screenwidth(), app.root.winfo_screenheight()
logging.debug('Window size is width: {screen_width}, height: {screen_height}')
tkimage = PIL.ImageTk.PhotoImage(resize_image(logo))
label_image = tkinter.Label(app.root, image=tkimage)
label_image.pack()
label_meta = tkinter.Label(app.root, text=email)
label_meta.config(
  font=('TkDefaultFont', 32),
  width=100,
  background='white')
label_meta.place(relx=0.5, y=0, anchor=tkinter.N)
app.root.after(cycle_time, next_image)
