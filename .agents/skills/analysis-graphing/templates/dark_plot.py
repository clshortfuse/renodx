"""Minimal RenoDX dark-theme matplotlib template.

Copy this into a scratch experiment or promote it into `tools/analysis/` when the
plot workflow becomes durable. Keep generated source data beside the image.
"""

from pathlib import Path

import matplotlib.pyplot as plt


def configure_dark_plot() -> None:
    plt.style.use("dark_background")
    plt.rcParams.update(
        {
            "figure.dpi": 150,
            "savefig.dpi": 170,
            "axes.grid": True,
            "grid.alpha": 0.22,
            "legend.framealpha": 0.85,
        }
    )


def save_figure(fig: plt.Figure, output_path: str | Path) -> None:
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.tight_layout()
    fig.savefig(output_path)
    plt.close(fig)


def example_plot(output_path: str | Path) -> None:
    configure_dark_plot()
    fig, ax = plt.subplots(figsize=(14, 9))
    x = [0, 0.18, 1, 4, 8]
    y = [0, 0.18, 1, 2, 3]
    ax.plot(x, y, label="candidate")
    ax.axvline(1, color="white", alpha=0.35, linestyle="--", label="diffuse white")
    ax.set_title("RenoDX comparison: replace with experiment name")
    ax.set_xlabel("Scene-linear input relative to diffuse white")
    ax.set_ylabel("Display-linear output relative to diffuse white")
    ax.legend()
    save_figure(fig, output_path)


if __name__ == "__main__":
    example_plot(Path("scratch_outputs") / "renodx_dark_plot_example.png")