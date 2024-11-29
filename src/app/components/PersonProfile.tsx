import React from "react";
import Image from "next/image";
import {FaEnvelope, FaPhoneAlt} from "react-icons/fa";
import Link from "next/link";

interface Props {
    name: string;
    title: string;
    imagePath: string;
    children: React.ReactNode;
}
const PersonProfile = ({ name, title, imagePath, children }: Props) => {
    return (
        <Link href="/contact" className="flex flex-col items-center text-center pb-8 border-2 border-gray-50 p-3 rounded-2xl hover:shadow-2xl hover:border-black">
            <div className="mb-4">
                <Image
                    src={imagePath}
                    alt={name}
                    width={200}
                    height={200}
                    className="rounded-full object-cover"
                />
            </div>
            <div className="items-center">
                <h2 className="text-xl font-semibold">{name}</h2>
                <p className="text-sm text-gray-600 mb-3">{title}</p>

                <div className="text-sm">
                    {children}
                </div>
            </div>
        </Link>
    );
};

export default PersonProfile;