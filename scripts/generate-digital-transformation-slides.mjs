import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = dirname(fileURLToPath(import.meta.url));
const projectRoot = resolve(scriptDir, "..");
const output = process.argv[2]
  || process.env.CHISELO_OUTPUT
  || resolve(projectRoot, "outputs", "digital-transformation-10-slides.html");

const visualSvg = encodeURIComponent(`
<svg xmlns="http://www.w3.org/2000/svg" width="960" height="540" viewBox="0 0 960 540">
  <rect width="960" height="540" rx="42" fill="#f6f1ff"/>
  <circle cx="182" cy="160" r="78" fill="#6d50b4" opacity=".92"/>
  <circle cx="782" cy="128" r="56" fill="#ffc107" opacity=".9"/>
  <circle cx="730" cy="392" r="84" fill="#c62828" opacity=".9"/>
  <rect x="286" y="98" width="392" height="72" rx="24" fill="#ffffff" stroke="#ded5ee" stroke-width="3"/>
  <rect x="230" y="230" width="500" height="92" rx="28" fill="#ffffff" stroke="#ded5ee" stroke-width="3"/>
  <rect x="314" y="376" width="332" height="64" rx="22" fill="#ffffff" stroke="#ded5ee" stroke-width="3"/>
  <path d="M482 170v60M482 322v54M286 134H182v26M678 134h104v-6M230 276H182V238M730 392h-84" stroke="#6d50b4" stroke-width="10" stroke-linecap="round" fill="none"/>
  <text x="482" y="144" text-anchor="middle" font-family="Arial, sans-serif" font-size="34" font-weight="800" fill="#15151b">Data Platform</text>
  <text x="482" y="286" text-anchor="middle" font-family="Arial, sans-serif" font-size="38" font-weight="800" fill="#15151b">AI + Workflow</text>
  <text x="482" y="418" text-anchor="middle" font-family="Arial, sans-serif" font-size="28" font-weight="800" fill="#15151b">Business Value</text>
</svg>`);

const html = `<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>数字化转型 10 页 HTML Slides</title>
  <style>
    :root {
      --bg: #f7f4fb;
      --surface: #ffffff;
      --tint: #f5efff;
      --ink: #15151b;
      --muted: #6f6a78;
      --primary: #6d50b4;
      --primary-dark: #4b3b78;
      --red: #c62828;
      --yellow: #ffc107;
      --gray: #6a6578;
      --line: #ded5ee;
      --shadow: 0 16px 34px rgba(49, 39, 70, .14);
      font-family: "PingFang SC", "Microsoft YaHei", -apple-system, BlinkMacSystemFont, sans-serif;
    }
    * { box-sizing: border-box; }
    html, body { margin: 0; min-height: 100%; background: #e9e5ef; color: var(--ink); }
    body { display: grid; justify-items: center; gap: 28px; padding: 28px; }
    .slide {
      position: relative;
      width: 1280px;
      height: 720px;
      overflow: hidden;
      background:
        linear-gradient(90deg, rgba(109,80,180,.055) 1px, transparent 1px),
        linear-gradient(rgba(109,80,180,.055) 1px, transparent 1px),
        var(--bg);
      background-size: 44px 44px;
      border-radius: 24px;
      box-shadow: 0 28px 70px rgba(49,39,70,.18);
      page-break-after: always;
    }
    .frame { position: absolute; inset: 48px 56px; }
    .kicker {
      margin: 0 0 18px;
      color: var(--primary);
      font-size: 20px;
      font-weight: 900;
      letter-spacing: 5px;
      text-transform: uppercase;
    }
    h1, h2, h3, p { margin: 0; }
    h1 { font-size: 74px; line-height: 1.04; letter-spacing: 0; max-width: 760px; }
    h2 { font-size: 46px; line-height: 1.08; letter-spacing: 0; max-width: 820px; }
    h3 { font-size: 25px; line-height: 1.2; letter-spacing: 0; }
    p { font-size: 22px; line-height: 1.45; color: var(--muted); }
    .subtitle { margin-top: 24px; max-width: 740px; font-size: 28px; font-weight: 650; color: var(--muted); }
    .accent-line { width: 92px; height: 7px; border-radius: 99px; background: var(--primary); margin: 22px 0 28px; }
    .material-card {
      background: var(--surface);
      border: 1px solid rgba(109,80,180,.12);
      border-radius: 24px;
      box-shadow: var(--shadow);
    }
    .hero-visual {
      position: absolute;
      right: 56px;
      top: 118px;
      width: 420px;
      height: 258px;
      object-fit: cover;
      border-radius: 24px;
      box-shadow: var(--shadow);
    }
    .page-no { position: absolute; right: 52px; bottom: 38px; color: #9b95a7; font-weight: 900; font-size: 20px; }
    .pill-row { display: flex; gap: 18px; margin-top: 34px; }
    .pill { border-radius: 999px; padding: 17px 26px; font-size: 20px; font-weight: 850; background: var(--surface); color: var(--primary-dark); box-shadow: var(--shadow); }
    .pill.filled { background: var(--primary); color: white; }
    .grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 22px; margin-top: 34px; }
    .grid-4 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-top: 30px; }
    .metric-card, .capability-card, .scenario-card, .risk-card {
      min-height: 150px;
      padding: 24px;
      background: var(--surface);
      border-radius: 24px;
      box-shadow: var(--shadow);
      border: 1px solid rgba(109,80,180,.12);
    }
    .metric-card b { display: block; font-size: 48px; color: var(--primary); line-height: 1; margin-bottom: 14px; }
    .metric-card span, .capability-card span, .scenario-card span, .risk-card span { display: block; margin-top: 10px; color: var(--muted); font-size: 18px; line-height: 1.35; }
    .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 28px; margin-top: 30px; align-items: stretch; }
    .component-row { display: grid; grid-template-columns: 160px 1fr; gap: 22px; align-items: center; padding: 24px 32px; margin-top: 18px; }
    .component-row .label { color: var(--primary); font-size: 18px; font-weight: 900; letter-spacing: 4px; }
    .bar-list { display: grid; gap: 18px; margin-top: 24px; }
    .bar { display: grid; grid-template-columns: 160px 1fr 72px; gap: 16px; align-items: center; }
    .track { height: 18px; border-radius: 99px; background: #e9e2f4; overflow: hidden; }
    .fill { height: 100%; border-radius: 99px; background: var(--primary); }
    .architecture { position: relative; height: 360px; margin-top: 36px; }
    .node { position: absolute; padding: 18px 26px; border-radius: 22px; background: white; box-shadow: var(--shadow); border: 1px solid rgba(109,80,180,.14); font-size: 22px; font-weight: 850; }
    .node.primary { background: var(--primary); color: white; }
    .connector { position: absolute; height: 6px; background: var(--primary); border-radius: 99px; opacity: .72; }
    .timeline { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-top: 34px; }
    .phase { padding: 24px; min-height: 250px; border-radius: 24px; background: white; box-shadow: var(--shadow); border-top: 8px solid var(--primary); }
    .phase b { color: var(--primary); font-size: 22px; }
    .roadmap-table { width: 100%; border-collapse: separate; border-spacing: 0; overflow: hidden; border-radius: 24px; box-shadow: var(--shadow); margin-top: 30px; background: white; }
    .roadmap-table th, .roadmap-table td { padding: 18px 20px; font-size: 19px; text-align: left; border-bottom: 1px solid #e7e1ef; }
    .roadmap-table th { background: var(--primary); color: white; font-weight: 900; }
    .roadmap-table td { color: var(--muted); }
    .dashboard { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 22px; margin-top: 32px; }
    .gauge { width: 118px; height: 118px; border-radius: 50%; display: grid; place-items: center; background: conic-gradient(var(--primary) 0 76%, #ebe5f3 76%); margin-bottom: 16px; }
    .gauge::after { content: attr(data-value); width: 82px; height: 82px; border-radius: 50%; background: white; display: grid; place-items: center; font-size: 24px; font-weight: 900; }
    .quote { position: absolute; left: 90px; right: 90px; top: 225px; padding: 46px 58px; text-align: center; }
    .quote h2 { max-width: none; }
    @media print {
      body { display: block; padding: 0; background: white; }
      .slide { box-shadow: none; border-radius: 0; page-break-after: always; }
    }
  </style>
</head>
<body>
  <section class="slide cover">
    <div class="frame">
      <p class="kicker">Digital Transformation</p>
      <h1 class="hero-title">数字化转型路线图</h1>
      <div class="accent-line"></div>
      <p class="subtitle">从业务价值、数据底座、流程自动化到 AI 场景落地，形成可执行的 12 个月转型计划。</p>
      <div class="pill-row">
        <span class="pill filled">Strategy</span>
        <span class="pill">Data</span>
        <span class="pill">AI</span>
        <span class="pill">Governance</span>
      </div>
      <img class="hero-visual" src="data:image/svg+xml,${visualSvg}" alt="digital transformation architecture visual">
      <span class="page-no">01</span>
    </div>
  </section>

  <section class="slide">
    <div class="frame">
      <p class="kicker">WHY NOW</p>
      <h2>转型不是上系统，而是重构组织的响应速度</h2>
      <div class="grid-3">
        <article class="metric-card"><b>42%</b><h3>流程等待</h3><span>跨部门审批、人工录入、信息断点消耗大量时间。</span></article>
        <article class="metric-card"><b>3.8x</b><h3>数据重复</h3><span>同一指标多套口径，影响经营判断和责任闭环。</span></article>
        <article class="metric-card"><b>12m</b><h3>落地窗口</h3><span>先从高频、高痛点、高确定性场景切入。</span></article>
      </div>
      <span class="page-no">02</span>
    </div>
  </section>

  <section class="slide">
    <div class="frame">
      <p class="kicker">MATURITY</p>
      <h2>数字化成熟度诊断</h2>
      <div class="material-card component-row"><div class="label">INPUT</div><p>业务、数据、流程、系统、组织五个维度同步评估。</p></div>
      <div class="bar-list material-card" style="padding:28px 34px;">
        <div class="bar"><h3>业务在线化</h3><div class="track"><div class="fill" style="width:72%"></div></div><p>72%</p></div>
        <div class="bar"><h3>数据可用性</h3><div class="track"><div class="fill" style="width:48%"></div></div><p>48%</p></div>
        <div class="bar"><h3>流程自动化</h3><div class="track"><div class="fill" style="width:36%"></div></div><p>36%</p></div>
        <div class="bar"><h3>AI 应用准备度</h3><div class="track"><div class="fill" style="width:29%"></div></div><p>29%</p></div>
      </div>
      <span class="page-no">03</span>
    </div>
  </section>

  <section class="slide">
    <div class="frame">
      <p class="kicker">CAPABILITY MODEL</p>
      <h2>四层能力模型</h2>
      <div class="grid-4">
        <article class="capability-card"><h3>业务对象</h3><span>客户、订单、项目、资产、合同统一编码。</span></article>
        <article class="capability-card"><h3>数据服务</h3><span>指标口径、数据资产目录、主数据治理。</span></article>
        <article class="capability-card"><h3>流程编排</h3><span>审批、通知、任务、异常处理自动化。</span></article>
        <article class="capability-card"><h3>智能决策</h3><span>预测、推荐、问答、风险提示嵌入工作流。</span></article>
      </div>
      <span class="page-no">04</span>
    </div>
  </section>

  <section class="slide">
    <div class="frame">
      <p class="kicker">DATA ARCHITECTURE</p>
      <h2>数据底座：从孤岛到服务</h2>
      <div class="architecture">
        <div class="node" style="left:20px; top:42px;">业务系统</div>
        <div class="node" style="left:20px; top:228px;">外部数据</div>
        <div class="connector" style="left:190px; top:86px; width:210px;"></div>
        <div class="connector" style="left:190px; top:272px; width:210px;"></div>
        <div class="node primary" style="left:410px; top:132px;">数据中台</div>
        <div class="connector" style="left:575px; top:176px; width:220px;"></div>
        <div class="node" style="right:28px; top:42px;">经营看板</div>
        <div class="node" style="right:28px; top:228px;">AI 场景</div>
      </div>
      <span class="page-no">05</span>
    </div>
  </section>

  <section class="slide">
    <div class="frame">
      <p class="kicker">WORKFLOW</p>
      <h2>流程自动化优先处理高频断点</h2>
      <div class="two-col">
        <article class="material-card" style="padding:30px;"><h3>当前断点</h3><p style="margin-top:16px;">人工汇总、重复录入、邮件追问、审批状态不可见。</p></article>
        <article class="material-card" style="padding:30px;"><h3>目标状态</h3><p style="margin-top:16px;">事件触发、系统派单、自动校验、异常升级、全程留痕。</p></article>
      </div>
      <div class="timeline">
        <article class="phase"><b>01</b><h3>识别</h3><p>找到业务量最大、等待时间最长的链路。</p></article>
        <article class="phase"><b>02</b><h3>重排</h3><p>删掉低价值节点，把责任和数据入口前移。</p></article>
        <article class="phase"><b>03</b><h3>自动化</h3><p>用规则引擎、RPA、API 串起动作。</p></article>
        <article class="phase"><b>04</b><h3>监控</h3><p>用仪表盘追踪时效、异常和满意度。</p></article>
      </div>
      <span class="page-no">06</span>
    </div>
  </section>

  <section class="slide">
    <div class="frame">
      <p class="kicker">AI SCENARIOS</p>
      <h2>AI 场景不是孤立应用，要嵌入工作流</h2>
      <div class="grid-3">
        <article class="scenario-card"><h3>知识问答</h3><span>制度、合同、项目文档的可信检索与摘要。</span></article>
        <article class="scenario-card"><h3>预测预警</h3><span>成本、交付、库存、风险的提前识别。</span></article>
        <article class="scenario-card"><h3>智能助理</h3><span>表单填报、报告生成、会议纪要、行动项跟踪。</span></article>
      </div>
      <div class="material-card component-row"><div class="label">TOGGLE</div><p>先以 Copilot 方式辅助人，再逐步让系统自动执行低风险动作。</p></div>
      <span class="page-no">07</span>
    </div>
  </section>

  <section class="slide">
    <div class="frame">
      <p class="kicker">ROADMAP</p>
      <h2>12 个月路线图</h2>
      <table class="roadmap-table">
        <thead><tr><th>阶段</th><th>重点任务</th><th>交付物</th><th>验收指标</th></tr></thead>
        <tbody>
          <tr><td>0-2 月</td><td>诊断与蓝图</td><td>场景清单 / 数据地图</td><td>Top 10 场景确认</td></tr>
          <tr><td>3-5 月</td><td>数据与流程试点</td><td>主数据 / 自动化流程</td><td>周期缩短 20%</td></tr>
          <tr><td>6-9 月</td><td>AI 场景上线</td><td>知识库 / 预测模型</td><td>覆盖 3 个部门</td></tr>
          <tr><td>10-12 月</td><td>规模化推广</td><td>治理机制 / 运营看板</td><td>ROI 可跟踪</td></tr>
        </tbody>
      </table>
      <span class="page-no">08</span>
    </div>
  </section>

  <section class="slide">
    <div class="frame">
      <p class="kicker">DASHBOARD</p>
      <h2>经营驾驶舱指标</h2>
      <div class="dashboard">
        <article class="metric-card"><div class="gauge" data-value="76%"></div><h3>流程自动化率</h3><span>高频流程自动触发和闭环。</span></article>
        <article class="metric-card"><div class="gauge" data-value="64%"></div><h3>数据可信度</h3><span>指标口径一致、来源可追溯。</span></article>
        <article class="metric-card"><div class="gauge" data-value="31%"></div><h3>AI 采用率</h3><span>从辅助场景向核心流程渗透。</span></article>
      </div>
      <span class="page-no">09</span>
    </div>
  </section>

  <section class="slide">
    <div class="frame">
      <p class="kicker">NEXT STEP</p>
      <div class="quote material-card">
        <h2>数字化转型的关键，是把变化做成可运行、可度量、可迭代的系统。</h2>
        <p style="margin-top:24px;">下一步：选择一个业务链路，用 30 天完成端到端样板。</p>
      </div>
      <span class="page-no">10</span>
    </div>
  </section>
</body>
</html>`;

mkdirSync(dirname(output), { recursive: true });
writeFileSync(output, html, "utf8");
console.log(output);
