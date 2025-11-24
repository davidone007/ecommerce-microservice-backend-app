#!/usr/bin/env python3

"""
Script de Comparación de Resultados
===================================

Compara resultados de múltiples ejecuciones de pruebas para identificar
tendencias, mejoras o degradaciones de rendimiento.

Uso:
    python compare_results.py results/test1_stats.csv results/test2_stats.csv
"""

import sys
import argparse
import pandas as pd
from pathlib import Path
from tabulate import tabulate


def load_test_results(csv_file):
    """Carga resultados de una prueba"""
    try:
        df = pd.read_csv(csv_file)
        return df
    except Exception as e:
        print(f"❌ Error al cargar {csv_file}: {e}")
        return None


def calculate_summary(df, test_name):
    """Calcula resumen de métricas para una prueba"""
    if df is None or df.empty:
        return None

    total_requests = df["Request Count"].sum()
    total_failures = df["Failure Count"].sum()

    return {
        "Test": test_name,
        "Total Requests": int(total_requests),
        "Failures": int(total_failures),
        "Success Rate (%)": (
            round((1 - total_failures / total_requests) * 100, 2)
            if total_requests > 0
            else 0
        ),
        "Avg Response (ms)": round(df["Average Response Time"].mean(), 2),
        "P95 (ms)": round(df["95%"].mean(), 2) if "95%" in df.columns else 0,
        "P99 (ms)": round(df["99%"].mean(), 2) if "99%" in df.columns else 0,
        "Avg RPS": round(df["Requests/s"].mean(), 2),
    }


def compare_tests(summaries):
    """Compara múltiples tests y genera tabla comparativa"""
    if len(summaries) < 2:
        print("⚠️  Se necesitan al menos 2 tests para comparar")
        return

    # Crear DataFrame
    df = pd.DataFrame(summaries)

    print("\n" + "=" * 100)
    print("📊 COMPARACIÓN DE RESULTADOS")
    print("=" * 100)
    print()
    print(tabulate(df, headers="keys", tablefmt="grid", showindex=False))
    print()

    # Calcular diferencias
    if len(summaries) == 2:
        baseline = summaries[0]
        current = summaries[1]

        print("📈 DIFERENCIAS (Baseline vs Current):")
        print("-" * 100)

        metrics = [
            ("Success Rate (%)", "success_rate", True),
            ("Avg Response (ms)", "avg_response", False),
            ("P95 (ms)", "p95", False),
            ("P99 (ms)", "p99", False),
            ("Avg RPS", "avg_rps", True),
        ]

        for label, key, higher_is_better in metrics:
            baseline_val = baseline.get(label, 0)
            current_val = current.get(label, 0)

            if baseline_val == 0:
                continue

            diff = current_val - baseline_val
            pct_change = (diff / baseline_val) * 100

            if higher_is_better:
                emoji = "✅" if diff > 0 else "⚠️" if diff < 0 else "➖"
            else:
                emoji = "✅" if diff < 0 else "⚠️" if diff > 0 else "➖"

            print(
                f"{emoji} {label}: {baseline_val:.2f} → {current_val:.2f} "
                f"({diff:+.2f}, {pct_change:+.1f}%)"
            )

        print("-" * 100)


def main():
    parser = argparse.ArgumentParser(
        description="Compara resultados de múltiples pruebas de rendimiento"
    )
    parser.add_argument(
        "csv_files", nargs="+", help="Archivos CSV con estadísticas (mínimo 2)"
    )

    args = parser.parse_args()

    if len(args.csv_files) < 2:
        print("❌ Error: Se necesitan al menos 2 archivos CSV para comparar")
        sys.exit(1)

    # Cargar resultados
    summaries = []
    for i, csv_file in enumerate(args.csv_files, 1):
        csv_path = Path(csv_file)
        if not csv_path.exists():
            print(f"❌ Error: {csv_file} no existe")
            continue

        print(f"📊 Cargando {csv_file}...")
        df = load_test_results(csv_file)

        if df is not None:
            test_name = f"Test {i} ({csv_path.stem})"
            summary = calculate_summary(df, test_name)
            if summary:
                summaries.append(summary)

    if len(summaries) < 2:
        print("❌ No se pudieron cargar suficientes resultados para comparar")
        sys.exit(1)

    # Comparar
    compare_tests(summaries)

    print("\n✅ Comparación completada\n")


if __name__ == "__main__":
    main()
