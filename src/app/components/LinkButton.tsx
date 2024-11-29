import Link from "next/link";

interface Props {
  name: string;
  href: string;
}
const LinkButton = ({ name, href }: Props) => {
  return (
    <Link href={href}>
      <button className="text-white text-2xl bg-violet-500 hover:bg-violet-600 active:bg-violet-700 focus:outline-none focus:ring focus:ring-violet-300 p-3 rounded-2xl mb-10">
        {name}
      </button>
    </Link>
  );
};

export default LinkButton;
