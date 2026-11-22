import React, { useState } from 'react';
import { ArrowDown, ArrowRight, ArrowUpRight, Aperture, ScanLine, Microscope, ShieldCheck, Database, FileText, WifiOff, ChevronDown, Menu, X, CircleHelp, Github, BookOpen } from 'lucide-react';

const RELEASE = 'https://github.com/Adams-404/microtrace/releases/latest';
const REPO = 'https://github.com/Adams-404/microtrace';
const biasLogo = 'https://raw.githubusercontent.com/Adams-404/microtrace/main/docs/branding/BIAS-logo-white.png';

const steps = [
  { id: 'capture', number: '01', title: 'Capture with intention', eyebrow: 'OPTICAL INGESTION', body: 'Bring the microscope field into focus with a native camera pipeline, optical reticle and direct control over zoom, exposure and illumination.', details: ['CameraX live stream', 'Focus and exposure lock', 'Reticle and field alignment'], icon: Aperture },
  { id: 'assess', number: '02', title: 'Know when the image is ready', eyebrow: 'IMAGE QUALITY', body: 'Each captured field is checked for sharpness, luminance, contrast and optical alignment before it moves into analysis.', details: ['Variance of Laplacian focus score', 'Luminance and contrast gates', 'Circular field auto-cropping'], icon: ScanLine },
  { id: 'review', number: '03', title: 'Keep the scientist in control', eyebrow: 'ASSISTED ANALYSIS', body: 'On-device models can propose findings. A qualified reviewer remains responsible for confirming, correcting or rejecting every interpretation.', details: ['Local LiteRT inference', 'Confidence and annotation review', 'Explicit human sign-off'], icon: Microscope },
  { id: 'document', number: '04', title: 'Leave a traceable record', eyebrow: 'LABORATORY RECORD', body: 'Sessions, images, model metadata and reviewer decisions stay connected in a local record, ready for structured export.', details: ['Drift SQLite persistence', 'Vector PDF reports', 'Structured audit JSON'], icon: FileText },
];

const faqs = [
  ['Does MICROTRACE need an internet connection?', 'No. The workstation is designed to operate offline. Sessions, images, analysis records and reports are stored locally on the device. Internet access may be needed to obtain app or model updates.'],
  ['Does MICROTRACE make medical diagnoses?', 'No. MICROTRACE is a research-use-only scientific decision-support tool. Automated outputs are proposals, not diagnoses, and must be verified by a qualified microscopist or pathologist before any clinical action.'],
  ['What equipment do I need?', 'A compatible Android smartphone, an optical light microscope and a mechanical smartphone-to-eyepiece adapter. The phone camera is used to capture the microscope field.'],
  ['Where can I get the Android app?', 'The latest Android release is published on GitHub Releases. Use the download button on this page to view the current release and its available APK assets.'],
];

function FieldArtwork() {
  return <div className="field-art" aria-label="Illustrative microscope field showing fungal structures">
    <div className="field-top"><span>MICROSCOPY / FIELD 014</span><span>40× OBJECTIVE</span></div>
    <svg className="field-svg" viewBox="0 0 620 620" role="img" aria-label="Illustrative microscopy field with branching hyphae and spores">
      <defs>
        <clipPath id="lensClip"><circle cx="310" cy="310" r="268" /></clipPath>
        <radialGradient id="lensBg"><stop offset="0" stopColor="#d9d8bd"/><stop offset=".72" stopColor="#aeb69b"/><stop offset="1" stopColor="#7f8c78"/></radialGradient>
        <filter id="soft"><feGaussianBlur stdDeviation="3"/></filter>
      </defs>
      <circle cx="310" cy="310" r="278" fill="#242b25"/>
      <circle cx="310" cy="310" r="268" fill="url(#lensBg)"/>
      <g clipPath="url(#lensClip)" fill="none" strokeLinecap="round">
        <g stroke="#495b46" strokeWidth="8" opacity=".86">
          <path d="M60 500 C155 420 178 360 242 312 S350 238 410 160 S515 90 575 35"/>
          <path d="M160 404 C115 365 95 315 55 285 M235 320 C220 258 182 216 151 166"/>
          <path d="M340 254 C350 320 405 357 465 380 S540 430 582 505"/>
          <path d="M406 164 C380 115 389 72 415 35 M470 105 C500 145 535 155 590 160"/>
          <path d="M250 310 C280 360 277 422 250 480"/>
        </g>
        <g stroke="#e6e4c8" strokeWidth="2.5" opacity=".8">
          <path d="M60 500 C155 420 178 360 242 312 S350 238 410 160 S515 90 575 35"/>
          <path d="M160 404 C115 365 95 315 55 285 M235 320 C220 258 182 216 151 166"/>
          <path d="M340 254 C350 320 405 357 465 380 S540 430 582 505"/>
        </g>
        <g fill="#59684e" stroke="#e6e4c8" strokeWidth="2">
          <ellipse cx="110" cy="449" rx="14" ry="21" transform="rotate(42 110 449)"/><ellipse cx="179" cy="369" rx="12" ry="18" transform="rotate(28 179 369)"/>
          <ellipse cx="292" cy="278" rx="15" ry="20" transform="rotate(53 292 278)"/><ellipse cx="375" cy="208" rx="13" ry="18" transform="rotate(28 375 208)"/>
          <ellipse cx="485" cy="112" rx="16" ry="21" transform="rotate(40 485 112)"/><ellipse cx="452" cy="373" rx="15" ry="20" transform="rotate(-38 452 373)"/>
          <ellipse cx="260" cy="437" rx="14" ry="19" transform="rotate(12 260 437)"/>
        </g>
        <g fill="#87936c" opacity=".7" filter="url(#soft)">
          {Array.from({length:34},(_,i)=><circle key={i} cx={(i*83+47)%590+15} cy={(i*137+61)%590+15} r={(i%4)+5}/>)}
        </g>
      </g>
      <circle cx="310" cy="310" r="268" fill="none" stroke="#f4f2eb" strokeWidth="2" opacity=".7"/>
      <path d="M310 34v18 M310 568v18 M34 310h18 M568 310h18" stroke="#f4f2eb" strokeWidth="2" opacity=".8"/>
      <circle cx="310" cy="310" r="5" fill="#f4f2eb"/>
    </svg>
    <div className="field-bottom"><span>ILLUSTRATIVE OPTICAL FIELD</span><span>MICROTRACE / 001</span></div>
    <div className="field-note"><span className="live-dot"></span> FIELD VIEW / CONCEPTUAL</div>
  </div>;
}

function App() {
  const [active, setActive] = useState('capture');
  const [openFaq, setOpenFaq] = useState(0);
  const [menuOpen, setMenuOpen] = useState(false);
  const activeStep = steps.find(s => s.id === active) || steps[0];
  const Icon = activeStep.icon;

  return <main>
    <header className="nav wrap">
      <a className="brand" href="#top" aria-label="Microtrace home"><span className="brand-mark"><Aperture size={21}/></span><span>MICROTRACE</span></a>
      <nav className={menuOpen ? 'nav-links open' : 'nav-links'}>
        <a href="#companion" onClick={()=>setMenuOpen(false)}>The workspace</a>
        <a href="#principles" onClick={()=>setMenuOpen(false)}>Principles</a>
        <a href="#questions" onClick={()=>setMenuOpen(false)}>Questions</a>
      </nav>
      <div className="nav-actions">
        <a className="nav-github" href={REPO} target="_blank" rel="noreferrer"><Github size={16}/> Repository</a>
        <a className="button button-dark nav-download" href={RELEASE} target="_blank" rel="noreferrer">Download app <ArrowUpRight size={16}/></a>
      </div>
      <button className="menu-toggle" onClick={()=>setMenuOpen(!menuOpen)} aria-label="Toggle navigation">{menuOpen?<X/>:<Menu/>}</button>
    </header>

    <section className="hero wrap" id="top">
      <div className="hero-copy">
        <div className="eyebrow"><span className="eyebrow-line"></span> A DIGITAL WORKSPACE FOR SCIENTIFIC WORK</div>
        <h1>See the<br/><em>smaller</em><br/>picture.</h1>
        <p className="hero-lede">A considered workspace for the work around discovery. Capture observations, organise experiments, keep laboratory records and bring your scientific work into one offline-first companion.</p>
        <div className="hero-buttons">
          <a className="button button-dark" href={RELEASE} target="_blank" rel="noreferrer">Get MICROTRACE <ArrowUpRight size={17}/></a>
          <a className="text-link" href="#workstation">Explore the workstation <ArrowDown size={15}/></a>
        </div>
        <div className="hero-meta"><span>ANDROID APPLICATION</span><i></i><span>OFFLINE-FIRST BY DESIGN</span><i></i><span>RESEARCH USE ONLY</span></div>
      </div>
      <div className="hero-visual"><FieldArtwork/><div className="visual-caption"><span>01 / THE OPTICAL FIELD</span><span>Illustrative visualization</span></div></div>
      <div className="hero-index"><span>MT—001</span><span>AN INSTRUMENT FOR CLOSER LOOKS</span></div>
    </section>

    <section className="statement">
      <div className="wrap statement-inner"><span className="section-index">01 — THE IDEA</span><div><h2>A scientist's work doesn't end at the eyepiece. <em>Neither should the tools.</em></h2><p>MICROTRACE is being shaped as a practical companion for the whole research process: a place to plan work, document methods, track samples, record observations, review results and preserve the context behind every finding. Microscopy is one instrument in that wider workflow, not the whole story.</p></div></div>
    </section>


    <section className="companion wrap section-pad" id="companion">
      <div className="section-heading"><div><span className="section-index">02 — THE SCIENTIST'S WORKSPACE</span><h2>More than a view<br/>through the lens.</h2></div><p>Scientific work is made of many small, connected actions. MICROTRACE is designed to give those actions a shared home.</p></div>
      <div className="companion-intro"><span className="dot-label">A BROADER DIRECTION</span><p>Think of it as a field notebook, lab organiser and research companion in one. These are the areas we're exploring as MICROTRACE grows.</p></div>
      <div className="companion-grid">
        <article className="companion-card"><span className="companion-icon"><FileText size={21}/></span><span className="companion-no">01 / RECORD</span><h3>Research notebook</h3><p>Write dated entries, capture observations, attach images and keep the reasoning behind a result close to the result itself.</p><span className="companion-tag">NOTES · OBSERVATIONS · ATTACHMENTS</span></article>
        <article className="companion-card"><span className="companion-icon"><Database size={21}/></span><span className="companion-no">02 / ORGANISE</span><h3>Experiments & projects</h3><p>Group work into projects, experiment runs and repeatable studies. Keep objectives, conditions, outcomes and follow-up work connected.</p><span className="companion-tag">PROJECTS · RUNS · OUTCOMES</span></article>
        <article className="companion-card"><span className="companion-icon"><ScanLine size={21}/></span><span className="companion-no">03 / TRACE</span><h3>Samples & specimens</h3><p>Give samples their own records. Track identifiers, collection details, preparation notes, storage location and the experiments they appear in.</p><span className="companion-tag">SAMPLE IDs · METADATA · HISTORY</span></article>
        <article className="companion-card"><span className="companion-icon"><BookOpen size={21}/></span><span className="companion-no">04 / STANDARDISE</span><h3>Protocols & methods</h3><p>Keep procedures close to the work. Build reusable method templates, record deviations and note exactly how an experiment was performed.</p><span className="companion-tag">SOPs · CHECKLISTS · VERSIONS</span></article>
        <article className="companion-card"><span className="companion-icon"><Microscope size={21}/></span><span className="companion-no">05 / MAINTAIN</span><h3>Equipment & lab activity</h3><p>Keep practical details from getting lost: equipment records, maintenance notes, calibration dates, consumables and reminders.</p><span className="companion-tag">EQUIPMENT · STOCK · REMINDERS</span></article>
        <article className="companion-card"><span className="companion-icon"><ShieldCheck size={21}/></span><span className="companion-no">06 / COMMUNICATE</span><h3>Reports & traceability</h3><p>Bring notes, images, measurements and decisions together in clear reports, with a record of what changed and who reviewed it.</p><span className="companion-tag">EXPORTS · REVIEW · ACTIVITY HISTORY</span></article>
      </div>
      <p className="companion-footnote"><span className="live-dot"></span> PRODUCT DIRECTION — THESE CAPABILITIES ARE PLANNED AREAS OF DEVELOPMENT, NOT A CLAIM THAT THEY ARE ALL AVAILABLE TODAY.</p>
    </section>

    <section className="workstation wrap section-pad" id="workstation">
      <div className="section-heading"><div><span className="section-index">03 — THE WORKFLOW</span><h2>From eyepiece<br/>to evidence.</h2></div><p>Four connected stages. One local record. A scientist in control at every step.</p></div>
      <div className="workflow-layout">
        <div className="workflow-list" role="tablist" aria-label="Workstation stages">
          {steps.map(s=><button key={s.id} role="tab" aria-selected={active===s.id} className={active===s.id?'workflow-tab selected':'workflow-tab'} onClick={()=>setActive(s.id)}>
            <span className="workflow-number">{s.number}</span><span className="workflow-title">{s.title}</span><ArrowUpRight className="workflow-arrow" size={17}/>
          </button>)}
        </div>
        <div className="workflow-detail" role="tabpanel">
          <div className="detail-top"><span>{activeStep.eyebrow}</span><span>STAGE {activeStep.number} / 04</span></div>
          <div className="detail-icon"><Icon size={26}/></div>
          <h3>{activeStep.title}</h3><p>{activeStep.body}</p>
          <ul>{activeStep.details.map(d=><li key={d}><span className="check">+</span>{d}</li>)}</ul>
          <div className="detail-foot"><span>MICROTRACE WORKFLOW</span><span>{activeStep.number} — 04</span></div>
        </div>
      </div>
    </section>

    <section className="principles" id="principles">
      <div className="wrap section-pad">
        <div className="section-heading light-heading"><div><span className="section-index">04 — THE DESIGN PRINCIPLES</span><h2>Designed for the<br/><em>real laboratory.</em></h2></div><p>Not another cloud dashboard. A focused instrument that respects the realities of scientific work.</p></div>
        <div className="principle-grid">
          <article><WifiOff/><span className="principle-num">01</span><h3>Works without the cloud</h3><p>Core workflows run on the device. Your sessions and records stay local, with no account or connection required for everyday use.</p></article>
          <article><ScanLine/><span className="principle-num">02</span><h3>Quality before inference</h3><p>Image-quality heuristics help identify blur, exposure issues and optical misalignment before analysis begins.</p></article>
          <article><ShieldCheck/><span className="principle-num">03</span><h3>Human review is explicit</h3><p>Model outputs remain assistive proposals. Confirmation, correction and rejection belong to the qualified reviewer.</p></article>
          <article><Database/><span className="principle-num">04</span><h3>Records stay connected</h3><p>Images, sessions, model metadata and review decisions are linked in a local relational database and can be exported.</p></article>
        </div>
      </div>
    </section>

    <section className="spec-section wrap section-pad">
      <div className="section-heading"><div><span className="section-index">05 — UNDER THE SURFACE</span><h2>Thoughtful by<br/>construction.</h2></div><p>The engineering is intentionally practical: native camera access, local persistence and transparent review.</p></div>
      <div className="spec-table">
        <div><span>OPTICAL INGESTION</span><strong>CameraX native streaming</strong><small>Zoom · focus lock · exposure · torch</small></div>
        <div><span>IMAGE QUALITY</span><strong>Classical computer vision</strong><small>Laplacian sharpness · luminance · alignment</small></div>
        <div><span>MODEL RUNTIME</span><strong>On-device LiteRT</strong><small>Local inference · model metadata · checksums</small></div>
        <div><span>DATA LAYER</span><strong>Drift + SQLite</strong><small>Offline relational records · indexed queries</small></div>
        <div><span>EXPORT</span><strong>Scientific PDF + JSON</strong><small>Quality summaries · audit records · sign-off</small></div>
      </div>
      <div className="integrity-note"><ShieldCheck size={19}/><p><strong>Research use only.</strong> MICROTRACE is a scientific decision-support tool, not an autonomous diagnostic system. All model outputs require independent review by a qualified professional before clinical action.</p></div>
    </section>

    <section className="download-band">
      <div className="wrap download-inner"><div><span className="section-index">06 — TAKE IT TO THE MICROSCOPE</span><h2>Make more of<br/><em>what you can see.</em></h2><p>Download the latest Android release and pair your phone with a compatible optical microscope.</p><a className="button button-cream" href={RELEASE} target="_blank" rel="noreferrer">Download for Android <ArrowUpRight size={17}/></a></div><div className="download-aside"><span className="download-mark"><Aperture size={48}/></span><span>MICROTRACE / ANDROID</span><span>Latest release on GitHub</span><a href={RELEASE} target="_blank" rel="noreferrer">View release notes <ArrowUpRight size={14}/></a></div></div>
    </section>

    <section className="faq wrap section-pad" id="questions">
      <div className="section-heading"><div><span className="section-index">07 — GOOD TO KNOW</span><h2>Before you<br/>look closer.</h2></div><p>A few practical details about the workstation, its use and its limits.</p></div>
      <div className="faq-list">{faqs.map(([q,a],i)=><div className={openFaq===i?'faq-item active':'faq-item'} key={q}><button onClick={()=>setOpenFaq(openFaq===i?-1:i)} aria-expanded={openFaq===i}><span>{q}</span><ChevronDown size={18}/></button>{openFaq===i&&<p>{a}</p>}</div>)}</div>
    </section>

    <footer className="footer">
      <div className="wrap footer-top"><div className="footer-brand"><a className="brand" href="#top"><span className="brand-mark"><Aperture size={21}/></span><span>MICROTRACE</span></a><p>A digital workspace for scientific work.</p></div><div className="footer-links"><a href="#companion">Workspace</a><a href="#principles">Principles</a><a href={REPO} target="_blank" rel="noreferrer">GitHub <ArrowUpRight size={13}/></a><a href={RELEASE} target="_blank" rel="noreferrer">Downloads <ArrowUpRight size={13}/></a></div><div className="footer-parent"><span>A PRODUCT OF</span><a href="https://bias.science" target="_blank" rel="noreferrer"><img src={biasLogo} alt="BIAS — Basira Institute for Advanced Science"/></a><small>Basira Institute for Advanced Science</small></div></div>
      <div className="wrap footer-bottom"><span>© {new Date().getFullYear()} MICROTRACE · BIAS</span><span>BUILT FOR CLOSER OBSERVATION.</span><span>RESEARCH USE ONLY</span></div>
    </footer>
  </main>;
}

export default App;