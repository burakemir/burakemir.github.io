## Clone repo

```
git clone git@github.com:burakemir/burakemir.github.io.git
git switch zola
git submodule update --init --recursive
```

## Set up zola
```
podman pull ghcr.io/getzola/zola:v0.20.0
```

## Build
```
podman run  -v $PWD/src:/app \
  --workdir /app ghcr.io/getzola/zola:v0.20.0 build
```

## Serve
```
podman run -p 8080:8080 -v $PWD/src:/app \
--workdir /app ghcr.io/getzola/zola:v0.20.0 \
serve --interface 0.0.0.0 --port 8080 --base-url localhost
```
