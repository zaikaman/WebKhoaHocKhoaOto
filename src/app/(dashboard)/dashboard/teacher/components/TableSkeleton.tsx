
import { Skeleton } from "@/components/ui/skeleton";

export function TableSkeleton({ rows = 5, cells = 5 }) {
  return (
    <div className="rounded-md border">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b">
            {[...Array(cells)].map((_, i) => (
              <th key={i} className="h-12 px-4 text-left">
                <Skeleton className="h-6 w-full" />
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {[...Array(rows)].map((_, i) => (
            <tr key={i} className="border-b">
              {[...Array(cells)].map((_, j) => (
                <td key={j} className="p-4">
                  <Skeleton className="h-6 w-full" />
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
