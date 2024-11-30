import LinkButton from "../components/LinkButton";

export default function Waitlist() {
  return (
    <div className="bg-gradient-to-r from-blue-400 to-purple-300 min-h-screen flex flex-col antialiased">
      <section className="text-center py-12">
        {/* Company Introduction Section */}
        <h1 className="text-6xl font-bold mb-6">Join the Waitlist</h1>
        <p className="text-xl max-w-4xl mx-auto mb-6">
          Malvon is relatively new and we are working hard to make it available
          to everyone. If you would like to try Malvon before it is released to
          the public, please join our waitlist.
        </p>

        <LinkButton
          name="Join the waitlist"
          href="https://app.youform.com/forms/bwwl0dko"
        />
      </section>
    </div>
  );
}
