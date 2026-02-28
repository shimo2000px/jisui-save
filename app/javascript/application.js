import "@hotwired/turbo-rails"
import "./controllers"

document.addEventListener("turbo:load", () => {
  const ctx = document.getElementById("savingsChart");
  if (!ctx) return;

  const annotation = window['chartjs-plugin-annotation'] || window.chartjsPluginAnnotation;
  if (annotation) {
    Chart.register(annotation);
  }

  const existingChart = Chart.getChart(ctx);
  if (existingChart) existingChart.destroy();

  const rawTarget = ctx.getAttribute("data-target-amount");
  const targetAmount = parseInt(rawTarget, 10) || 0;
  let labels = JSON.parse(ctx.dataset.labels || "[]");
  let values = JSON.parse(ctx.dataset.values || "[]");

  const latestValue = values.length > 0 ? values[values.length - 1] : 0;
  const isGoalReached = targetAmount > 0 && latestValue >= targetAmount;

  const themeColor = isGoalReached ? "#22c55e" : "#f97316";
  const areaColor = isGoalReached ? "rgba(34, 197, 94, 0.1)" : "rgba(249, 115, 22, 0.1)";

  const isMobile = window.innerWidth < 768;
  const labelsToUse = isMobile && labels.length > 7 ? labels.slice(-7) : labels;
  const valuesToUse = isMobile && values.length > 7 ? values.slice(-7) : values;

  const formattedLabels = labelsToUse.map(label => {
    const date = new Date(label);
    return isNaN(date) ? label : `${date.getMonth() + 1}/${date.getDate()}`;
  });

  new Chart(ctx, {
    type: "line",
    data: {
      labels: formattedLabels,
      datasets: [{
        label: "累計節約額",
        data: valuesToUse,
        borderColor: themeColor,
        backgroundColor: areaColor,
        borderWidth: 3,
        fill: true,
        tension: 0.4,
        pointRadius: isMobile ? 3 : 4,
        pointBackgroundColor: themeColor
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      layout: {
        padding: { top: 35, right: 20, left: 10, bottom: 0 }
      },
      plugins: {
        legend: { display: false },
        annotation: {
          annotations: {
            goalLine: {
              type: 'line',
              drawTime: 'afterDatasetsDraw',
              yMin: targetAmount,
              yMax: targetAmount,
              borderColor: isGoalReached ? "#10b981" : "red",
              borderWidth: 2,
              borderDash: [6, 6],
              label: {
                display: targetAmount > 0,
                content: isGoalReached ? "🎉 目標達成！" : `目標: ¥${targetAmount.toLocaleString()}`,
                position: 'end',
                backgroundColor: isGoalReached ? "#22c55e" : "rgba(239, 68, 68, 0.8)",
                color: '#fff',
                font: { size: 10, weight: 'bold' },
                yAdjust: -15,
                enabled: true
              },
              zIndex: 10
            }
          }
        },
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
          suggestedMax: targetAmount > 0 ? targetAmount * 1.2 : 5000,
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
            autoSkip: true, 
            maxTicksLimit: isMobile ? 5 : 10 
          },
          grid: { display: false }
        }
      }
    }
  });

  if (isGoalReached) {
    if (typeof confetti === 'function') {
      confetti({
        particleCount: 150,
        spread: 70,
        origin: { y: 0.6 },
        zIndex: 9999
      });
    }

    const toast = document.getElementById('achievement-toast');
    if (toast) {
      setTimeout(() => {
        toast.classList.add('opacity-0', 'transition-opacity', 'duration-1000');
        setTimeout(() => toast.remove(), 1000);
      }, 5000);
    }
  }
});