const canvas = document.getElementById('hilbert');
canvas.width = canvas.offsetWidth;
canvas.height = canvas.offsetHeight;
const ctx = canvas.getContext('2d');
ctx.translate(-0.5, -0.5);
ratio = Math.min(canvas.width / 1000, canvas.height / 1000);

let startx = canvas.width  * 2/(1 + Math.sqrt(5));
let starty = canvas.height * 2/(1 + Math.sqrt(5));
let startphi = Math.PI / 2;

document.body.onresize = function() {
  canvas.width = canvas.offsetWidth;
  canvas.height = canvas.offsetHeight;
  startx = canvas.width  * 2/(1 + Math.sqrt(5));
  starty = canvas.height * 2/(1 + Math.sqrt(5));
};

let x = startx;
let y = starty;
let phi = startphi;

function turn(sign) {
  if (sign > 0) { rt(); } else { lt(); }
}

function hilbert(depth, len, sign) {
  if (depth == 0) {
    turn(-sign);  // -
    fd(len / 3);  // F
    turn(sign);   // +
    fd(len / 3);  // F
    turn(sign);   // +
    fd(len / 3);  // F
    turn(-sign);  // -
  } else {
    let ndepth = depth - 1;
    let nlen = len / 3;
    turn(-sign);                  // -
    hilbert(ndepth, len, -sign)   // (-A)
    fd(nlen);                     // F
    turn(sign);                   // +
    hilbert(ndepth, len, sign);   // A
    fd(nlen);                     // F
    hilbert(ndepth, len, sign);   // A
    turn(sign);                   // +
    fd(nlen);                     // F
    hilbert(ndepth, len, -sign);  // (-A)
    turn(-sign);                  // -
  }
}

function home() {
  x = startx;
  y = starty;
  phi = 0;
}

function clear() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
}

function fd(len) {
  ctx.beginPath()
  ctx.moveTo(x, y);
  x += len * Math.cos(phi);
  y -= len * Math.sin(phi);
  ctx.lineTo(x, y);
  ctx.stroke();
}

function rt() { phi += Math.PI / 2; }
function lt() { phi -= Math.PI / 2; }

function rotate(angle) {
  ctx.translate(startx, starty);
  ctx.rotate(angle);
  ctx.translate(-startx, -starty);
}

function draw3(angle, col) {
  wrap(function() { hilbert(3, 70 * ratio, -1); }, angle, col);
};

function draw4(angle, col) {
  wrap(function() { hilbert(4, 45 * ratio, -1); }, angle, col);
};


function draw5(angle, col) {
  wrap(function() { hilbert(5, 27 * ratio, -1); hilbert(5, 27 * ratio, -1); }, angle, col);
}

function wrap(fn, angle, col) {
  home();
  rotate(angle);
  let old = ctx.strokeStyle;
  ctx.strokeStyle = col;
  fn();
  ctx.strokeStyle = old;
  rotate(-angle);
}

function hex(n) {
  let s = n.toString(16);
  return (s.length < 2) ? "0" + s : s;
}

function fadeIn(fn, offset, angle) {
  let frame_duration = 10;
  for (t = 0; t < 125; t += 10) {
    let alpha = hex(255 - t);
    setTimeout(fn, offset + t * frame_duration, angle, "#" + alpha + alpha + alpha);
  }
  setTimeout(fadeOut, 125 * frame_duration, fn, offset, angle);
}

function fadeOut(fn, offset, angle) {
  let frame_duration = 12;
  for (t = 0; t < 125; t += 10) {
    let alpha = hex(125 + t);
    setTimeout(fn, offset + t * frame_duration, angle, "#" + alpha + alpha + alpha);
  }
  setTimeout(fn, offset + 125 * frame_duration, angle, "white");
}

function getRandomAngle() {
  return Math.random() * 2 * Math.PI;
}

function animate() {
  clear();
  ctx.lineWidth = 1;
  setTimeout(draw4, 150, getRandomAngle(), '#'+Math.random().toString(16).substr(2,6));
  setTimeout(draw5, 200, getRandomAngle(), '#'+Math.random().toString(16).substr(2,6));
  for (n = 0; n < 40; ++n) {
    fadeIn(draw3, n * 100, n * Math.PI/10);
  }
}

animate();
let timer = setInterval(animate, 7000);
setTimeout(function() { clearInterval(timer); clear(); }, 25000);
