import os
import subprocess
import matplotlib.pyplot as plt
import base64
from io import BytesIO
from jinja2 import Template

# Parameters
X = 0.1  # Threshold for no AluY insertion
Y = 0.3  # Threshold for AluY insertion detection

# Get all sample names based on R1 files
sample_names = sorted({f.replace("_R1.fastq.gz", "") for f in os.listdir() if f.endswith("_R1.fastq.gz")})

for sample_name in sample_names:
    # Paired-end files
    R1_file = f"{sample_name}_R1.fastq.gz"
    R2_file = f"{sample_name}_R2.fastq.gz"

    # Run shell commands to compute mutant and wildtype counts
    mutant_count = int(
        subprocess.check_output(
            f"find {R1_file} {R2_file} -type f | parallel -j+1 zgrep -c -e ACCGCGCCCGGCCGTGTTTTCTTTGG -e CCAAAGAAAACACGGCCGGGCGCGGT | awk '{{sum += $1}} END {{print sum}}'",
            shell=True,
            text=True,
        ).strip()
    )
    wildtype_count = int(
        subprocess.check_output(
            f"find {R1_file} {R2_file} -type f | parallel -j+1 zgrep -c -e GTTATCAGTATATGTGTTTTCTTTGG -e CCAAAGAAAACACATATACTGATAAC | awk '{{sum += $1}} END {{print sum}}'",
            shell=True,
            text=True,
        ).strip()
    )

    # Calculate total depth and VAF
    total_depth = mutant_count + wildtype_count
    vaf_value = mutant_count / total_depth if total_depth > 0 else 0

    # Determine result based on VAF
    if vaf_value < X:
        result = "VAF < 0.1 : No AluY insertion was found in exon 4 of RP1 at chr8:54627934 position (hg38)."
        result_class = "no-insertion"
    elif vaf_value >= Y:
        result = "VAF >= 0.3 : AluY insertion was detected in exon 4 of RP1 at chr8:54627934 position (hg38)."
        result_class = "detected"
    else:
        result = "0.1 <= VAF < 0.3 : AluY insertion was suspected in exon 4 of RP1 at chr8:54627934 position (hg38). Please recheck by visualizing AluY sequence at chr8:54627934 position (hg38)."
        result_class = "suspected"

    # Generate a bar chart
    plt.figure(figsize=(6, 4))
    categories = ['Mutant', 'Wildtype']
    counts = [mutant_count, wildtype_count]
    plt.bar(categories, counts, color=['#3498db', '#e74c3c'])
    plt.ylabel('Count')
    plt.title('Comparison of Mutant and Wildtype Reads')
    plt.tight_layout()

    # Save bar chart to a BytesIO buffer
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    plt.close()
    buffer.seek(0)
    bar_chart_base64 = base64.b64encode(buffer.read()).decode('utf-8')
    buffer.close()

    # Generate an HTML report for the sample
    html_template = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{{ sample_name }} RP1 AluY Analysis</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Roboto', sans-serif;
                margin: 20px;
                padding: 20px;
                background-color: #f9f9f9;
                color: #333;
                max-width: 800px;
                margin: auto;
                border: 1px solid #ccc;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            h1 {
                color: #2c3e50;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }
            table, th, td {
                border: 1px solid #ddd;
            }
            th, td {
                padding: 10px;
                text-align: left;
            }
            th {
                background-color: #f4f4f4;
            }
            .result {
                font-size: 1.2em;
                padding: 10px;
                border-radius: 5px;
                color: #fff;
            }
            .no-insertion {
                background-color: #3498db;
            }
            .detected {
                background-color: #e74c3c;
            }
            .suspected {
                background-color: #f39c12;
            }
        </style>
    </head>
    <body>
        <h1>{{ sample_name }} RP1 AluY Insertion Analysis</h1>
        <table>
            <tr>
                <th>Metric</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Mutant Count</td>
                <td>{{ mutant_count }}</td>
            </tr>
            <tr>
                <td>Wildtype Count</td>
                <td>{{ wildtype_count }}</td>
            </tr>
            <tr>
                <td>Total Depth</td>
                <td>{{ total_depth }}</td>
            </tr>
            <tr>
                <td>Variant Allele Frequency (VAF)</td>
                <td>{{ "%.2f"|format(vaf_value) }}</td>
            </tr>
        </table>
        <div class="result {{ result_class }}">{{ result }}</div>
        <h2>Comparison of Mutant and Wildtype Reads</h2>
        <img src="data:image/png;base64,{{ bar_chart_base64 }}" alt="Bar Chart">
    </body>
    </html>
    """

    html_content = Template(html_template).render(
        sample_name=sample_name,
        mutant_count=mutant_count,
        wildtype_count=wildtype_count,
        total_depth=total_depth,
        vaf_value=vaf_value,
        result=result,
        result_class=result_class,
        bar_chart_base64=bar_chart_base64,
    )

    # Save the HTML report
    html_output_file = f"{sample_name}.RP1_Alu_analysis.html"
    with open(html_output_file, "w") as html_file:
        html_file.write(html_content)

    print(f"Generated report: {html_output_file}")

print("Analysis completed for all samples.")
