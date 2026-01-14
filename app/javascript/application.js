import "@hotwired/turbo-rails"
import "./controllers"
import Chart from 'chart.js/auto';
import annotationPlugin from 'chartjs-plugin-annotation'; // 将来的に目標設定と紐つかせるため

Chart.register(annotationPlugin);

document.addEventListener("turbo:load", () => {
  const ctx = document.getElementById("savingsChart");
  if (!ctx) return;

  const existingChart = Chart.getChart(ctx);
  if (existingChart) existingChart.destroy();

  let labels = JSON.parse(ctx.dataset.labels);
  let values = JSON.parse(ctx.dataset.values);

  const isMobile = window.innerWidth < 768;

  if (isMobile && labels.length > 7) {
    labels = labels.slice(-7);
    values = values.slice(-7);
  }

  const formattedLabels = labels.map(label => {
    const date = new Date(label);
    if (isNaN(date)) return label;
    return `${date.getMonth() + 1}/${date.getDate()}`;
  });

  new Chart(ctx, {
    type: "line",
    data: {
      labels: formattedLabels,
      datasets: [{
        label: "累計節約額",
        data: values,
        borderColor: "#f97316",
        backgroundColor: "rgba(249, 115, 22, 0.1)",
        borderWidth: 3,
        fill: true,
        tension: 0.4,
        pointRadius: isMobile ? 3 : 4,
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      layout: {
        padding: {
          left: 5,
          right: 15,
          top: 10,
          bottom: 0
        }
      },
      plugins: {
        legend: { display: false },
        tooltip: {
          mode: 'index',
          intersect: false,
          callbacks: {
            label: (context) => `累計: ¥${context.parsed.y.toLocaleString()}`
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            font: { size: 10 },
            callback: (value) => '¥' + value.toLocaleString(),
            maxTicksLimit: 6 
          }
        },
        x: {
          ticks: {
            font: { size: 9 }, 
            maxRotation: 0,
            minRotation: 0,
            autoSkip: true, 
            maxTicksLimit: isMobile ? 5 : 10 
          },
          grid: {
            display: false
          }
        }
      }
    }
  });
});