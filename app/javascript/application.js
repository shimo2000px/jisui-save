import "@hotwired/turbo-rails"
import "./controllers"
import Chart from 'chart.js/auto';
import annotationPlugin from 'chartjs-plugin-annotation'; // 将来的に目標設定と紐つかせるため

Chart.register(annotationPlugin); // 将来的に目標設定と紐つかせるため

document.addEventListener("turbo:load", () => {
  const ctx = document.getElementById("savingsChart");
  if (!ctx) return;

  const existingChart = Chart.getChart(ctx);
  if (existingChart) existingChart.destroy();

  const labels = JSON.parse(ctx.dataset.labels);
  const values = JSON.parse(ctx.dataset.values);

  new Chart(ctx, {
    type: "line",
    data: {
      labels: labels,
      datasets: [{
        label: "累計節約額",
        data: values,
        borderColor: "#f97316",
        backgroundColor: "rgba(249, 115, 22, 0.1)",
        borderWidth: 3,
        fill: true,
        tension: 0.4
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true, ticks: { callback: (value) => '¥' + value.toLocaleString() } },
        x: { ticks: { maxTicksLimit: 7 } }
      }
    }
  });
});