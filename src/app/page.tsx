import Image from "next/image";
import LinkButton from "./components/LinkButton";
import {
  FaBatteryFull,
  FaBolt,
  FaVectorSquare,
  FaGhost,
  FaApple,
} from "react-icons/fa";

export default function Home() {
  const reasons = [
    {
      title: "WebKit",
      description:
        "The WebKit Browser Engine is natively optimized for macOS and is the same engine that powers Safari. This means that Malvon is just as fast, if not faster and efficient as Apple's native Safari.",
      icon: <FaBolt className="text-4xl text-purple-600 mb-4" />,
    },
    {
      title: "Power",
      description: "Malvon is designed to be as power-efficient as possible.",
      icon: <FaBatteryFull className="text-4xl text-purple-600 mb-4" />,
    },
    {
      title: "Native App",
      description:
        "Malvon is a native macOS application, which means that it is designed to look and feel like a macOS application. In addition to utilizing native macOS features.",
      icon: <FaApple className="text-4xl text-purple-600 mb-4" />,
    },
    {
      title: "Lightweight",
      description: "The Malvon application is less than 5 mb of space!",
      icon: <FaGhost className="text-4xl text-purple-600 mb-4" />,
    },
    {
      title: "Modern Style",
      description:
        "Malvon is designed with a modern and clean user interface that is easy to use and navigate. Along with vertical tabs..",
      icon: <FaVectorSquare className="text-4xl text-purple-600 mb-4" />,
    },
  ];

  return (
    <div className="bg-gradient-to-r from-red-400 to-pink-200 min-h-screen flex flex-col antialiased">
      <section className="text-center py-12">
        {/* Company Introduction Section */}
        <h1 className="text-6xl font-bold mb-6">Introducing Malvon</h1>
        <p className="text-xl max-w-4xl mx-auto mb-6">
          A new browser for macOS. Malvon is a fast, lightweight, and
          privacy-focused browser that is designed to be simple and easy to use.
          This project is being developed with the primary goal of battery life
          in mind.
        </p>

        <Image
          src="/Malvon-Light.png"
          alt="Malvon Logo"
          width={200}
          height={160}
          sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw,"
          style={{ height: "100%", width: "100%" }}
        />
      </section>

      {/* Why Malvon Section */}
      <section className="py-12 text-center">
        <h2 className="text-6xl font-bold text-purple-700 mb-8">Why Malvon?</h2>
        <LinkButton name="Join the waitlist" href="/waitlist" />
        <div className="grid gap-8 sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3 mx-auto max-w-6xl">
          {reasons.map((reason, index) => (
            <div
              key={index}
              className="bg-white bg-opacity-90 rounded-lg p-8 text-gray-800 shadow-md flex flex-col items-center"
            >
              {reason.icon}
              <h3 className="text-2xl font-bold mb-2 text-center">
                {reason.title}
              </h3>
              <p className="text-lg text-center">{reason.description}</p>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
