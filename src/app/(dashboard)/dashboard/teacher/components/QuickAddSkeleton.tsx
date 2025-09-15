
import { Skeleton } from "@/components/ui/skeleton";

export function QuickAddSkeleton() {
  return (
    <div className="space-y-8 container mx-auto py-10">
      {/* Header */}
      <div className="space-y-2">
        <Skeleton className="h-8 w-1/4" />
        <Skeleton className="h-4 w-1/2" />
      </div>

      {/* Class selection */}
      <div className="space-y-4 rounded-lg border p-4">
        <Skeleton className="h-6 w-1/4" />
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <Skeleton className="h-12 rounded-lg" />
          <Skeleton className="h-12 rounded-lg" />
          <Skeleton className="h-12 rounded-lg" />
        </div>
      </div>

      {/* Type selection */}
      <div className="space-y-4 rounded-lg border p-4">
        <Skeleton className="h-6 w-1/4" />
        <div className="flex gap-4">
          <Skeleton className="h-10 w-24" />
          <Skeleton className="h-10 w-24" />
          <Skeleton className="h-10 w-24" />
          <Skeleton className="h-10 w-24" />
        </div>
      </div>

      {/* Form */}
      <div className="space-y-4 rounded-lg border p-4">
        <Skeleton className="h-6 w-1/4 mb-4" />
        <div className="space-y-4">
          <div className="space-y-2">
            <Skeleton className="h-4 w-1/6" />
            <Skeleton className="h-10 w-full" />
          </div>
          <div className="space-y-2">
            <Skeleton className="h-4 w-1/6" />
            <Skeleton className="h-24 w-full" />
          </div>
        </div>
      </div>

      <Skeleton className="h-10 w-32" />
    </div>
  );
}
