import React from 'react';
import { Link } from 'react-router-dom';

import ContactIcons from '../Contact/ContactIcons';

const { PUBLIC_URL } = process.env; // set automatically from package.json:homepage

const SideBar = () => (
  <section id="sidebar">
    <section id="intro">
      <Link to="/" className="logo">
        <img src={`${PUBLIC_URL}/images/me.jpg`} alt="" />
      </Link>
      <header>
        <h2>Logan Clemons</h2>
        <p><a href="mailto:loganrclemons@gmail.com">loganrclemons@gmail.com</a></p>
      </header>
    </section>

    <section className="blurb">
      <h2>About</h2>
      <p>Hi, I&apos;m Logan. I&apos;m a cloud engineer. Let me build stuff for you.
        I am a graduate of <a href="https://www.jmu.edu/index.shtml">James Madison University</a>
        , and <a href="https://www.apsu.edu/">Austin Peay State University</a>
        . I was a developer and SRE at <a href="https://www.davita.com/">Davita</a>
        , and I am currently a Cloud Engineer at <a href="https://planet.com">Lirio</a>
        , a behavioral science ai healthcare startup.
      </p>
      <ul className="actions">
        <li>
          {!window.location.pathname.includes('/resume') ? <Link to="/resume" className="button">Learn More</Link> : <Link to="/about" className="button">About Me</Link>}
        </li>
      </ul>
    </section>

    <section id="footer">
      <ContactIcons />
      <p className="copyright">&copy; Logan Clemons <Link to="/">loganrobertclemons.com</Link>.</p>
    </section>
  </section>
);

export default SideBar;
