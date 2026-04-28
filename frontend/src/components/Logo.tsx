import { Link } from "react-router-dom";
import { cn } from "@/lib/cn";

type Props = {
  size?: "sm" | "md" | "lg";
  asLink?: boolean;
  className?: string;
};

export default function Logo({ size = "md", asLink = true, className }: Props) {
  const sizes = {
    sm: { box: "w-8 h-8 text-base", text: "text-lg" },
    md: { box: "w-10 h-10 text-lg", text: "text-xl" },
    lg: { box: "w-14 h-14 text-2xl", text: "text-3xl" },
  }[size];

  const content = (
    <div className={cn("flex items-center gap-2.5", className)}>
      <div
        className={cn(
          "rounded-2xl bg-gradient-tiktok bg-[length:200%_200%] animate-gradient-x grid place-items-center font-display font-extrabold text-white shadow-neon",
          sizes.box
        )}
      >
        F
      </div>
      <span
        className={cn(
          "font-display font-extrabold tracking-tight text-white",
          sizes.text
        )}
      >
        Fin<span className="text-gradient-static">Ku</span>
      </span>
    </div>
  );

  if (asLink) {
    return (
      <Link to="/" className="inline-flex">
        {content}
      </Link>
    );
  }
  return content;
}
