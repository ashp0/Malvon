"use client";
import React, { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";

const Header = () => {
  const path = usePathname();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  const menus = [
    { title: "Waitlist", href: "/waitlist" },
    { title: "Home", href: "/" },
    { title: "Docs", href: "https://github.com/ashp0/malvon-website/wiki" },
  ];

  const toggleMobileMenu = () => {
    console.log("MENU OPEN.");
    setIsMobileMenuOpen(!isMobileMenuOpen);
  };

  return (
    <header>
      <nav className="flex items-center justify-between p-6 bg-gray-100 shadow stickyNav relative">
        {/* Logo */}
        <div className="absolute left-4">
          <Link href="/" className="text-2xl font-bold text-red-200">
            Malvon
          </Link>
        </div>

        {/* Desktop Menu */}
        <div className="flex-grow flex justify-center">
          <ul className="flex space-x-8">
            {menus.map((item) => {
              const isActive = item.href === path;
              return (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    className={`m-5 ${
                      isActive ? "text-blue-500 font-semibold" : "text-gray-600"
                    }`}
                  >
                    {item.title}
                  </Link>
                </li>
              );
            })}
          </ul>
        </div>

        {/* Free Consultation Button for Desktop */}
        <div className="absolute right-4 hidden md:block">
          <button className="select-none border-2 border-violet-500 hover:bg-violet-600 active:bg-violet-700 focus:outline-none focus:ring focus:ring-violet-300 px-4 py-2 rounded-2xl text-white">
            <Link href="/waitlist">Join the waitlist</Link>
          </button>
        </div>

        {/* Mobile Menu Toggle Button */}
        <div className="md:hidden">
          <button onClick={toggleMobileMenu} className="text-gray-700">
            Menu
          </button>
        </div>

        {/* Mobile Menu */}
        {isMobileMenuOpen && (
          <div className="absolute top-16 left-0 w-full bg-gray-100 shadow-lg md:hidden">
            <ul className="flex flex-col items-start p-4 space-y-2">
              {menus.map((item) => {
                const isActive = item.href === path;
                return (
                  <li key={item.href} className="hover:text-blue-400">
                    <Link
                      href={item.href}
                      className={`block ${
                        isActive
                          ? "text-blue-500 font-semibold border border-blue-500"
                          : "text-gray-700"
                      }`}
                      onClick={() => setIsMobileMenuOpen(false)} // Close menu on link click
                    >
                      {item.title}
                    </Link>
                  </li>
                );
              })}
            </ul>
          </div>
        )}
      </nav>
    </header>
  );
};

export default Header;
