"""Etheris Flow — frosted glass helpers for Menu / Session overlays.

One-shot grim+ImageMagick blur (not permanent compositor blur).
Blur is independent of animations= ; motion fade/rise respects animations=.
"""
from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path

SETTINGS = Path(
    os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config")),
    "etheris",
    "settings.conf",
)

# Shared CSS: soft fade + rise. Instant when animations=off (caller skips enter).
# Prefer opacity + translate-like margin (GTK CSS has no reliable transform here).
GLASS_MOTION_CSS = b"""
.eth-glass-enter {
  opacity: 0;
  margin-top: -14px;
  transition: none;
}
.eth-glass-open {
  opacity: 1;
  margin-top: 0px;
  transition: opacity 280ms cubic-bezier(0.16, 1, 0.3, 1),
              margin-top 280ms cubic-bezier(0.16, 1, 0.3, 1);
}
.eth-glass-leave {
  opacity: 0;
  margin-top: -10px;
  transition: opacity 180ms cubic-bezier(0.4, 0, 1, 1),
              margin-top 180ms cubic-bezier(0.4, 0, 1, 1);
}
.eth-scrim-enter {
  opacity: 0;
  transition: none;
}
.eth-scrim-open {
  opacity: 1;
  transition: opacity 260ms cubic-bezier(0.16, 1, 0.3, 1);
}
.eth-scrim-leave {
  opacity: 0;
  transition: opacity 180ms cubic-bezier(0.4, 0, 1, 1);
}
"""


def setting(key: str, default: str = "") -> str:
    if not SETTINGS.is_file():
        return default
    try:
        with SETTINGS.open(encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if line.startswith(f"{key}="):
                    return line.split("=", 1)[1].strip()
    except OSError:
        pass
    return default


def animations_on() -> bool:
    return setting("animations", "off").lower() in ("on", "1", "true", "yes")


def want_blur() -> bool:
    """Frosted backdrop: on by default when tools exist; not tied to animations=."""
    env = os.environ.get("ETHERIS_GLASS_BLUR", os.environ.get("ETHERIS_POWER_BLUR", "")).strip()
    if env == "0":
        return False
    if env == "1":
        return True
    if setting("blur", "on") == "off":
        return False
    return bool(shutil.which("grim") and (shutil.which("magick") or shutil.which("convert")))


def prepare_frosted_backdrop(path: str, *, strength: str = "soft") -> bool:
    """Capture screen → downscale → blur → upscale into path. Returns True on success."""
    if not want_blur():
        return False
    grim = shutil.which("grim")
    magick = shutil.which("magick") or shutil.which("convert")
    if not grim or not magick:
        return False

    # soft = Menu; strong = Session fullscreen
    if strength == "strong":
        scale, blur, contrast, resize = "9%", "0x3.5", "-14x-12", "1112%"
    else:
        scale, blur, contrast, resize = "11%", "0x3.0", "-10x-8", "910%"

    raw = path + ".raw.png"
    try:
        subprocess.run([grim, raw], check=True, timeout=5)
        subprocess.run(
            [
                magick,
                raw,
                "-scale",
                scale,
                "-gaussian-blur",
                blur,
                "-resize",
                resize,
                "-brightness-contrast",
                contrast,
                path,
            ],
            check=True,
            timeout=12,
        )
        return os.path.isfile(path)
    except (subprocess.SubprocessError, OSError):
        return False
    finally:
        try:
            os.unlink(raw)
        except OSError:
            pass


def close_ms() -> int:
    return 0 if not animations_on() else 190


def lib_dir() -> Path:
    return Path(__file__).resolve().parent
